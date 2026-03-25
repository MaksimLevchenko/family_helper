import 'package:test/test.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:family_helper_server/src/generated/protocol.dart';
import 'package:family_helper_server/src/core/storage/private_media_storage_service.dart';
import 'package:family_helper_server/src/privacy/services/privacy_service.dart';
import 'package:family_helper_server/src/workers/future_call_names.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/future_call_entry.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

class _FailingPrivateMediaStorageService extends PrivateMediaStorageService {
  @override
  PrivateMediaStorageService forSession(Session session) => this;

  @override
  Future<void> storeBytes(
    Session session, {
    required String path,
    required Uint8List bytes,
  }) {
    throw StateError('simulated privacy export storage failure');
  }
}

void main() {
  withServerpod(
    'Privacy workers',
    (sessionBuilder, endpoints) {
      test(
        'requestExport schedules privacy worker for immediate execution',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final runId = DateTime.now().toUtc().microsecondsSinceEpoch;

          final before = DateTime.now().toUtc();
          final job = await endpoints.privacy.requestExport(
            owner,
            clientOperationId: 'privacy-export-immediate-$runId',
          );

          expect(job.status, 'pending');

          final scheduledEntry = await withDbSession(owner, (session) async {
            return FutureCallEntry.db.findFirstRow(
              session,
              where: (t) => t.identifier.equals(
                FutureCallNames.privacyExportIdentifier,
              ),
            );
          });

          expect(scheduledEntry, isNotNull);
          expect(
            scheduledEntry!.time.isBefore(
              before.add(const Duration(seconds: 15)),
            ),
            isTrue,
          );
        },
      );

      test(
        'export worker creates payload and deletion worker hard-deletes profile',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final runId = DateTime.now().toUtc().microsecondsSinceEpoch;

          final family = await endpoints.family.createFamily(
            owner,
            clientOperationId: 'privacy-family-create-$runId',
            title: 'Privacy Family $runId',
          );
          expect(family.id, greaterThan(0));

          final job = await endpoints.privacy.requestExport(
            owner,
            clientOperationId: 'privacy-export-$runId',
          );
          expect(job.status, 'pending');

          final privacyService = PrivacyService();
          final processedExports = await withDbSession(
            owner,
            privacyService.processExportJobs,
          );
          expect(processedExports, 1);

          final exportStatus = await withDbSession(owner, (session) async {
            return PrivacyExportJobRow.db.findById(session, job.id);
          });

          expect(exportStatus!.status, 'ready');
          final signedUrl = exportStatus.signedUrl;
          expect(signedUrl, isNotNull);
          expect(signedUrl!.startsWith('data:application/json;'), isFalse);
          expect(
            Uri.parse(signedUrl).path,
            PrivateMediaStorageService.privateMediaRoutePath,
          );

          final exportedPayload = await withDbSession(owner, (session) async {
            final storage = PrivateMediaStorageService().forSession(session);
            final validation = storage.validateSignedDownloadUri(
              Uri.parse(signedUrl),
            );
            expect(validation.isValid, isTrue);
            final byteData = await storage.retrieveBytes(
              session,
              path: exportStatus.objectKey,
            );
            return utf8.decode(Uint8List.sublistView(byteData!));
          });
          expect(exportedPayload, contains('"profileId":${job.profileId}'));

          final deletion = await endpoints.privacy.requestAccountDeletion(
            owner,
            clientOperationId: 'privacy-delete-$runId',
          );
          expect(deletion.status, 'scheduled');

          await withDbSession(owner, (session) async {
            final row = await AccountDeletionRequestRow.db.findFirstRow(
              session,
              where: (t) => t.profileId.equals(deletion.profileId),
            );
            await AccountDeletionRequestRow.db.updateRow(
              session,
              row!.copyWith(
                scheduledHardDeleteAt: DateTime.now().toUtc().subtract(
                  const Duration(minutes: 1),
                ),
              ),
            );
          });

          final processedDeletion = await withDbSession(
            owner,
            privacyService.processHardDeletion,
          );
          expect(processedDeletion, 1);

          final profileDeletedAt = await withDbSession(owner, (session) async {
            final row = await AppProfileRow.db.findById(
              session,
              deletion.profileId,
            );
            return row!.deletedAt;
          });
          expect(profileDeletedAt, isNotNull);

          final deletionStatus = await withDbSession(owner, (session) async {
            final row = await AccountDeletionRequestRow.db.findFirstRow(
              session,
              where: (t) => t.profileId.equals(deletion.profileId),
            );
            return row!.status;
          });
          expect(deletionStatus, 'hard_deleted');
        },
      );

      test(
        'export worker marks job failed when storage write throws',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final runId = DateTime.now().toUtc().microsecondsSinceEpoch;

          final job = await endpoints.privacy.requestExport(
            owner,
            clientOperationId: 'privacy-export-failure-$runId',
          );
          expect(job.status, 'pending');

          final privacyService = PrivacyService(
            storage: _FailingPrivateMediaStorageService(),
          );
          final processedExports = await withDbSession(
            owner,
            privacyService.processExportJobs,
          );
          expect(processedExports, 0);

          final exportStatus = await withDbSession(owner, (session) async {
            return PrivacyExportJobRow.db.findById(session, job.id);
          });

          expect(exportStatus, isNotNull);
          expect(exportStatus!.status, 'failed');
          expect(exportStatus.signedUrl, isNull);
          expect(exportStatus.expiresAt, isNull);
          expect(exportStatus.completedAt, isNotNull);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
