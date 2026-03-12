import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Family rename', (sessionBuilder, endpoints) {
    test('owner can rename family and receive updated dto', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-rename-001',
        title: 'Weekend Crew',
      );

      final renamed = await endpoints.family.renameFamily(
        owner,
        familyId: family.id,
        clientOperationId: 'family-rename-001',
        title: 'Home Team',
      );

      expect(renamed.id, family.id);
      expect(renamed.title, 'Home Team');
    });

    test('non-owner cannot rename family', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final member = authenticatedBuilder(sessionBuilder, user2Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-rename-002',
        title: 'Private Family',
      );

      final invite = await endpoints.family.createInvite(
        owner,
        familyId: family.id,
        clientOperationId: 'family-invite-rename-001',
        inviteType: 'code',
      );

      await endpoints.family.acceptInvite(
        member,
        clientOperationId: 'family-accept-rename-001',
        tokenOrCode: invite.inviteCode,
      );

      await expectLater(
        () => endpoints.family.renameFamily(
          member,
          familyId: family.id,
          clientOperationId: 'family-rename-002',
          title: 'New Name',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
