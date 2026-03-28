import 'package:family_helper_server/src/generated/protocol.dart';
import 'package:family_helper_server/src/notifications/services/notifications_service.dart';
import 'package:test/test.dart';

void main() {
  group('buildDeactivatedDuplicatePushTokens', () {
    test('deactivates the same token for other profiles only', () {
      final now = DateTime.utc(2026, 3, 28, 10, 0);
      final tokens = [
        PushTokenRow(
          id: 1,
          profileId: 10,
          token: 'shared-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          version: 1,
        ),
        PushTokenRow(
          id: 2,
          profileId: 11,
          token: 'shared-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          version: 4,
        ),
        PushTokenRow(
          id: 3,
          profileId: 11,
          token: 'another-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          version: 2,
        ),
        PushTokenRow(
          id: 4,
          profileId: 12,
          token: 'shared-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          deletedAt: now.subtract(const Duration(hours: 1)),
          version: 3,
        ),
      ];

      final deactivated = buildDeactivatedDuplicatePushTokens(
        tokens: tokens,
        profileId: 11,
        token: 'shared-token',
        now: now,
      );

      expect(deactivated, hasLength(1));
      expect(deactivated.single.id, 1);
      expect(deactivated.single.deletedAt, now);
      expect(deactivated.single.updatedAt, now);
      expect(deactivated.single.version, 2);
    });
  });
}
