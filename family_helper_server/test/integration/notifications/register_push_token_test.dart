import 'package:test/test.dart';

import 'package:family_helper_server/src/core/auth/auth_context.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Notifications register push token',
    (sessionBuilder, endpoints) {
      test(
        'registerPushToken keeps one row per token and re-enables soft-disabled records',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final authContext = const AuthContext();
          final runId = DateTime.now().microsecondsSinceEpoch;
          final token = 'fcm-token-$runId';

          final firstResult = await endpoints.notifications.registerPushToken(
            owner,
            clientOperationId: 'register-push-token-first-$runId',
            token: token,
            platform: 'android',
            provider: 'fcm',
            deviceId: 'device-a',
            appVersion: '1.0.0',
          );
          expect(firstResult.success, isTrue);

          final secondResult = await endpoints.notifications.registerPushToken(
            owner,
            clientOperationId: 'register-push-token-second-$runId',
            token: token,
            platform: 'android',
            provider: 'fcm',
            deviceId: 'device-b',
            appVersion: '1.0.1',
          );
          expect(secondResult.success, isTrue);

          Future<PushTokenRow> loadRow() {
            return withDbSession(owner, (session) async {
              final profileId = await authContext.ensureProfileId(session);
              final rows = await PushTokenRow.db.find(
                session,
                where: (t) =>
                    t.profileId.equals(profileId) & t.token.equals(token),
              );
              expect(rows, hasLength(1));
              return rows.single;
            });
          }

          final updatedRow = await loadRow();
          expect(updatedRow.deviceId, 'device-b');
          expect(updatedRow.appVersion, '1.0.1');
          expect(updatedRow.deletedAt, isNull);
          expect(updatedRow.disabledAt, isNull);

          await withDbSession(owner, (session) async {
            final now = DateTime.now().toUtc();
            await PushTokenRow.db.updateRow(
              session,
              updatedRow.copyWith(
                deletedAt: now,
                disabledAt: now,
                lastErrorAt: now,
                version: updatedRow.version + 1,
              ),
            );
          });

          final thirdResult = await endpoints.notifications.registerPushToken(
            owner,
            clientOperationId: 'register-push-token-third-$runId',
            token: token,
            platform: 'android',
            provider: 'fcm',
            deviceId: 'device-c',
            appVersion: '1.0.2',
          );
          expect(thirdResult.success, isTrue);

          final restoredRow = await loadRow();
          expect(restoredRow.deviceId, 'device-c');
          expect(restoredRow.appVersion, '1.0.2');
          expect(restoredRow.deletedAt, isNull);
          expect(restoredRow.disabledAt, isNull);
          expect(restoredRow.lastErrorAt, isNull);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
