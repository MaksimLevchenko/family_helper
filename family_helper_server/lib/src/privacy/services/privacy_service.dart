import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/storage/minio_storage_service.dart';
import '../../generated/protocol.dart';

class PrivacyService {
  PrivacyService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    MinioStorageService? storage,
  }) : storage = storage ?? MinioStorageService();

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final MinioStorageService storage;

  Future<PrivacyExportJobDto> requestExport(
    Session session, {
    required String clientOperationId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'privacy.requestExport',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final existing = await PrivacyExportJobRow.db.findFirstRow(
          session,
          where: (t) => t.profileId.equals(profileId),
          orderBy: (t) => t.id,
          orderDescending: true,
          transaction: transaction,
        );
        if (existing != null) {
          return _mapExport(existing);
        }
      }

      final row = await PrivacyExportJobRow.db.insertRow(
        session,
        PrivacyExportJobRow(
          profileId: profileId,
          status: 'pending',
          objectKey:
              'exports/profile_$profileId/export_${clock.nowUtc().millisecondsSinceEpoch}.json',
          signedUrl: null,
          expiresAt: null,
          createdAt: clock.nowUtc(),
          completedAt: null,
        ),
        transaction: transaction,
      );

      return _mapExport(row);
    });
  }

  Future<AccountDeletionStatusDto> requestAccountDeletion(
    Session session, {
    required String clientOperationId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'privacy.requestDeletion',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final graceDays =
          int.tryParse(Platform.environment['DELETION_GRACE_DAYS'] ?? '30') ??
          30;
      final scheduled = clock.nowUtc().add(Duration(days: graceDays));

      final existing = await AccountDeletionRequestRow.db.findFirstRow(
        session,
        where: (t) => t.profileId.equals(profileId),
        transaction: transaction,
      );
      final row = existing == null
          ? await AccountDeletionRequestRow.db.insertRow(
              session,
              AccountDeletionRequestRow(
                profileId: profileId,
                status: 'scheduled',
                scheduledHardDeleteAt: scheduled,
                createdAt: clock.nowUtc(),
                cancelledAt: null,
              ),
              transaction: transaction,
            )
          : await AccountDeletionRequestRow.db.updateRow(
              session,
              existing.copyWith(
                status: 'scheduled',
                scheduledHardDeleteAt: scheduled,
                cancelledAt: null,
              ),
              transaction: transaction,
            );

      return _mapDeletion(row);
    });
  }

  Future<AccountDeletionStatusDto> cancelAccountDeletion(
    Session session,
  ) async {
    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      final now = clock.nowUtc();
      final existing = await AccountDeletionRequestRow.db.findFirstRow(
        session,
        where: (t) => t.profileId.equals(profileId),
        transaction: transaction,
      );

      if (existing == null) {
        throw AccessDeniedException(message: 'No deletion request found.');
      }

      final updated = await AccountDeletionRequestRow.db.updateRow(
        session,
        existing.copyWith(status: 'cancelled', cancelledAt: now),
        transaction: transaction,
      );
      return _mapDeletion(updated);
    });
  }

  Future<PrivacyStatusDto> getStatus(Session session) async {
    final profileId = await authContext.ensureProfileId(session);
    final latestExport = await PrivacyExportJobRow.db.findFirstRow(
      session,
      where: (t) => t.profileId.equals(profileId),
      orderBy: (t) => t.id,
      orderDescending: true,
    );
    final deletion = await AccountDeletionRequestRow.db.findFirstRow(
      session,
      where: (t) => t.profileId.equals(profileId),
      orderBy: (t) => t.id,
      orderDescending: true,
    );

    return PrivacyStatusDto(
      lastExportJob: latestExport == null ? null : _mapExport(latestExport),
      accountDeletion: deletion == null ? null : _mapDeletion(deletion),
    );
  }

  Future<int> processExportJobs(Session session) async {
    final pending = await session.db.transaction((transaction) async {
      final result = await session.db.unsafeQuery(
        '''
        UPDATE "privacy_export_job"
        SET "status" = 'processing'
        WHERE "id" IN (
          SELECT "id"
          FROM "privacy_export_job"
          WHERE "status" = 'pending'
          ORDER BY "id"
          LIMIT 100
          FOR UPDATE SKIP LOCKED
        )
        RETURNING "id", "profileId", "status", "objectKey", "signedUrl",
                  "expiresAt", "createdAt", "completedAt"
        ''',
        transaction: transaction,
      );

      return result
          .map((row) => PrivacyExportJobRow.fromJson(row.toColumnMap()))
          .toList();
    });

    int processed = 0;
    final storageClient = storage.forSession(session);
    for (final row in pending) {
      final id = row.id!;
      final profileId = row.profileId;
      final objectKey = row.objectKey;

      try {
        final payload = await _buildExportPayload(
          session,
          profileId: profileId,
          objectKey: objectKey,
        );
        final bytes = Uint8List.fromList(utf8.encode(jsonEncode(payload)));
        await storageClient.uploadBytes(
          objectKey,
          bytes,
          contentType: 'application/json',
        );
        final signedUrl = await storageClient.presignedGetUrl(objectKey);
        final expiresAt = clock.nowUtc().add(const Duration(hours: 24));

        await PrivacyExportJobRow.db.updateById(
          session,
          id,
          columnValues: (t) => [
            t.status('ready'),
            t.signedUrl(signedUrl),
            t.expiresAt(expiresAt),
            t.completedAt(clock.nowUtc()),
          ],
        );

        processed += 1;
      } catch (_) {
        await PrivacyExportJobRow.db.updateById(
          session,
          id,
          columnValues: (t) => [
            t.status('failed'),
            t.signedUrl(null),
            t.expiresAt(null),
            t.completedAt(clock.nowUtc()),
          ],
        );
      }
    }

    return processed;
  }

  Future<int> processHardDeletion(Session session) async {
    final due = await AccountDeletionRequestRow.db.find(
      session,
      where: (t) =>
          t.status.equals('scheduled') &
          (t.scheduledHardDeleteAt <= clock.nowUtc()),
    );

    int deleted = 0;
    for (final row in due) {
      final profileId = row.profileId;
      await session.db.transaction((transaction) async {
        final now = clock.nowUtc();

        await _reassignOrCloseOwnedFamilies(
          session,
          profileId: profileId,
          now: now,
          transaction: transaction,
        );

        final members = await FamilyMemberRow.db.find(
          session,
          where: (t) =>
              t.profileId.equals(profileId) & t.deletedAt.equals(null),
          transaction: transaction,
        );
        for (final m in members) {
          await FamilyMemberRow.db.updateRow(
            session,
            m.copyWith(
              status: 'deleted',
              deletedAt: now,
              updatedAt: now,
              version: m.version + 1,
            ),
            transaction: transaction,
          );
        }

        final pushTokens = await PushTokenRow.db.find(
          session,
          where: (t) =>
              t.profileId.equals(profileId) & t.deletedAt.equals(null),
          transaction: transaction,
        );
        for (final token in pushTokens) {
          await PushTokenRow.db.updateRow(
            session,
            token.copyWith(
              deletedAt: now,
              updatedAt: now,
              version: token.version + 1,
            ),
            transaction: transaction,
          );
        }

        final preferences = await NotificationPreferenceRow.db.find(
          session,
          where: (t) => t.profileId.equals(profileId),
          transaction: transaction,
        );
        for (final p in preferences) {
          await NotificationPreferenceRow.db.updateRow(
            session,
            p.copyWith(
              enabled: false,
              updatedAt: now,
              version: p.version + 1,
            ),
            transaction: transaction,
          );
        }

        final reminders = await ReminderRow.db.find(
          session,
          where: (t) =>
              t.profileId.equals(profileId) & t.status.equals('scheduled'),
          transaction: transaction,
        );
        for (final r in reminders) {
          await ReminderRow.db.updateRow(
            session,
            r.copyWith(status: 'cancelled', firedAt: now),
            transaction: transaction,
          );
        }

        final mediaObjects = await MediaObjectRow.db.find(
          session,
          where: (t) =>
              t.uploadedByProfileId.equals(profileId) &
              t.deletedAt.equals(null),
          transaction: transaction,
        );
        for (final mo in mediaObjects) {
          await MediaObjectRow.db.updateRow(
            session,
            mo.copyWith(
              status: 'deleted',
              deletedAt: now,
              updatedAt: now,
              version: mo.version + 1,
            ),
            transaction: transaction,
          );
        }

        final mediaAttachments = await MediaAttachmentRow.db.find(
          session,
          where: (t) =>
              t.createdByProfileId.equals(profileId) & t.deletedAt.equals(null),
          transaction: transaction,
        );
        for (final ma in mediaAttachments) {
          await MediaAttachmentRow.db.updateRow(
            session,
            ma.copyWith(deletedAt: now, version: ma.version + 1),
            transaction: transaction,
          );
        }

        final profile = await AppProfileRow.db.findById(
          session,
          profileId,
          transaction: transaction,
        );
        if (profile != null) {
          await AppProfileRow.db.updateRow(
            session,
            profile.copyWith(
              displayName: 'Deleted user #$profileId',
              timezone: 'UTC',
              avatarMediaId: null,
              analyticsOptIn: false,
              deletedAt: now,
              updatedAt: now,
              version: profile.version + 1,
            ),
            transaction: transaction,
          );

          await IdempotencyKeyRow.db.deleteWhere(
            session,
            where: (t) => t.actorAuthUserId.equals(profile.authUserId),
            transaction: transaction,
          );
        }

        final deletionRequest = await AccountDeletionRequestRow.db.findFirstRow(
          session,
          where: (t) => t.profileId.equals(profileId),
          transaction: transaction,
        );
        if (deletionRequest != null) {
          await AccountDeletionRequestRow.db.updateRow(
            session,
            deletionRequest.copyWith(
              status: 'hard_deleted',
              cancelledAt: null,
            ),
            transaction: transaction,
          );
        }
      });
      deleted += 1;
    }

    return deleted;
  }

  Future<Map<String, dynamic>> _buildExportPayload(
    Session session, {
    required int profileId,
    required String objectKey,
  }) async {
    final profile = await AppProfileRow.db.findById(session, profileId);
    final memberRows = await FamilyMemberRow.db.find(
      session,
      where: (t) => t.profileId.equals(profileId),
      orderBy: (t) => t.id,
    );
    final familyIds = memberRows.map((m) => m.familyId).toSet().toList();
    final families = familyIds.isEmpty
        ? <FamilyRow>[]
        : await FamilyRow.db.find(
            session,
            where: (t) => t.id.inSet(familyIds.toSet()),
          );
    final familiesById = {for (final f in families) f.id!: f};
    final preferencesRows = await NotificationPreferenceRow.db.find(
      session,
      where: (t) => t.profileId.equals(profileId),
      orderBy: (t) => t.id,
    );
    final remindersRows = await ReminderRow.db.find(
      session,
      where: (t) => t.profileId.equals(profileId),
      orderBy: (t) => t.id,
    );
    final mediaRows = await MediaObjectRow.db.find(
      session,
      where: (t) => t.uploadedByProfileId.equals(profileId),
      orderBy: (t) => t.id,
    );

    final exportPayload = <String, dynamic>{
      'meta': {
        'generatedAt': clock.nowUtc().toIso8601String(),
        'profileId': profileId,
        'objectKey': objectKey,
      },
      'profile': profile == null
          ? null
          : _jsonify({
              'id': profile.id,
              'auth_user_id': profile.authUserId,
              'display_name': profile.displayName,
              'timezone': profile.timezone,
              'avatar_media_id': profile.avatarMediaId,
              'analytics_opt_in': profile.analyticsOptIn,
              'created_at': profile.createdAt,
              'updated_at': profile.updatedAt,
              'deleted_at': profile.deletedAt,
            }),
      'familyMemberships': memberRows
          .map(
            (m) => _jsonify({
              'id': m.id,
              'family_id': m.familyId,
              'role': m.role,
              'status': m.status,
              'created_at': m.createdAt,
              'updated_at': m.updatedAt,
              'family_title': familiesById[m.familyId]?.title,
            }),
          )
          .toList(),
      'notificationPreferences': preferencesRows
          .map(
            (p) => _jsonify({
              'id': p.id,
              'notification_type': p.notificationType,
              'enabled': p.enabled,
              'quiet_hours_start': p.quietHoursStart,
              'quiet_hours_end': p.quietHoursEnd,
              'updated_at': p.updatedAt,
            }),
          )
          .toList(),
      'reminders': remindersRows
          .map(
            (r) => _jsonify({
              'id': r.id,
              'family_id': r.familyId,
              'entity_type': r.entityType,
              'entity_id': r.entityId,
              'remind_at': r.remindAt,
              'status': r.status,
              'payload_json': r.payloadJson,
              'fired_at': r.firedAt,
              'created_at': r.createdAt,
            }),
          )
          .toList(),
      'mediaObjects': mediaRows
          .map(
            (m) => _jsonify({
              'id': m.id,
              'family_id': m.familyId,
              'object_key': m.objectKey,
              'bucket': m.bucket,
              'mime_type': m.mimeType,
              'size_bytes': m.sizeBytes,
              'status': m.status,
              'created_at': m.createdAt,
              'updated_at': m.updatedAt,
              'deleted_at': m.deletedAt,
            }),
          )
          .toList(),
    };

    return exportPayload;
  }

  Future<void> _reassignOrCloseOwnedFamilies(
    Session session, {
    required int profileId,
    required DateTime now,
    required Transaction transaction,
  }) async {
    final ownedFamilies = await FamilyRow.db.find(
      session,
      where: (t) =>
          t.ownerProfileId.equals(profileId) & t.deletedAt.equals(null),
      orderBy: (t) => t.id,
      transaction: transaction,
    );

    for (final family in ownedFamilies) {
      final familyId = family.id!;

      final replacement = await FamilyMemberRow.db.findFirstRow(
        session,
        where: (t) =>
            t.familyId.equals(familyId) &
            t.profileId.notEquals(profileId) &
            t.status.equals('active') &
            t.deletedAt.equals(null),
        orderBy: (t) => t.id,
        transaction: transaction,
      );

      if (replacement != null) {
        await FamilyRow.db.updateRow(
          session,
          family.copyWith(
            ownerProfileId: replacement.profileId,
            updatedAt: now,
            version: family.version + 1,
          ),
          transaction: transaction,
        );
      } else {
        await FamilyRow.db.updateRow(
          session,
          family.copyWith(
            deletedAt: now,
            updatedAt: now,
            version: family.version + 1,
          ),
          transaction: transaction,
        );
      }
    }
  }

  Map<String, dynamic> _jsonify(Map<String, dynamic> row) {
    final result = <String, dynamic>{};
    for (final entry in row.entries) {
      result[entry.key] = _toJsonValue(entry.value);
    }
    return result;
  }

  dynamic _toJsonValue(dynamic value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }
    if (value is List) {
      return value.map(_toJsonValue).toList();
    }
    if (value is Map) {
      return value.map(
        (key, nestedValue) => MapEntry('$key', _toJsonValue(nestedValue)),
      );
    }
    return value;
  }

  PrivacyExportJobDto _mapExport(PrivacyExportJobRow row) {
    return PrivacyExportJobDto(
      id: row.id!,
      profileId: row.profileId,
      status: row.status,
      signedUrl: row.signedUrl,
      expiresAt: row.expiresAt,
      createdAt: row.createdAt,
      completedAt: row.completedAt,
    );
  }

  AccountDeletionStatusDto _mapDeletion(AccountDeletionRequestRow row) {
    return AccountDeletionStatusDto(
      id: row.id!,
      profileId: row.profileId,
      status: row.status,
      scheduledHardDeleteAt: row.scheduledHardDeleteAt,
      createdAt: row.createdAt,
      cancelledAt: row.cancelledAt,
    );
  }
}
