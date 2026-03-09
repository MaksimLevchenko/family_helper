import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../generated/protocol.dart';

class ProfileService {
  ProfileService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;

  Future<ProfileDto> getMyProfile(Session session) async {
    final profileId = await authContext.ensureProfileId(session);
    final profile = await AppProfileRow.db.findById(session, profileId);
    return _mapProfile(profile!);
  }

  Future<ProfileDto> updateMyProfile(
    Session session, {
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'profile.update',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      if (!isFresh) {
        final current = await _findById(
          session,
          profileId,
          transaction: transaction,
        );
        return current;
      }

      final row = await AppProfileRow.db.findById(
        session,
        profileId,
        transaction: transaction,
      );
      if (row == null) {
        throw AccessDeniedException(message: 'Profile not found.');
      }

      await AppProfileRow.db.updateRow(
        session,
        row.copyWith(
          displayName: displayName ?? row.displayName,
          timezone: timezone ?? row.timezone,
          avatarMediaId: avatarMediaId ?? row.avatarMediaId,
          analyticsOptIn: analyticsOptIn ?? row.analyticsOptIn,
          updatedAt: DateTime.now().toUtc(),
          version: row.version + 1,
        ),
        transaction: transaction,
      );

      return _findById(session, profileId, transaction: transaction);
    });
  }

  Future<ProfileDto> _findById(
    Session session,
    int profileId, {
    Transaction? transaction,
  }) async {
    final row = await AppProfileRow.db.findById(
      session,
      profileId,
      transaction: transaction,
    );
    return _mapProfile(row!);
  }

  ProfileDto _mapProfile(AppProfileRow row) {
    return ProfileDto(
      id: row.id!,
      authUserId: row.authUserId,
      displayName: row.displayName,
      timezone: row.timezone,
      avatarMediaId: row.avatarMediaId,
      analyticsOptIn: row.analyticsOptIn,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
