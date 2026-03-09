import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Family idempotency', (sessionBuilder, endpoints) {
    test(
      'createFamily returns the same family for duplicate operation id',
      () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);

        final first = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-001',
          title: 'Our Home',
        );

        final second = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-001',
          title: 'Our Home v2',
        );

        expect(second.id, first.id);
        expect(second.title, first.title);

        final members = await endpoints.family.listMembers(
          owner,
          familyId: first.id,
        );
        expect(members.length, 1);
        expect(members.first.role, 'owner');
      },
    );

    test(
      'createInvite returns the same invite for duplicate operation id',
      () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-invite-001',
          title: 'Invite Family',
        );

        final first = await endpoints.family.createInvite(
          owner,
          familyId: family.id,
          clientOperationId: 'family-invite-create-001',
          inviteType: 'email',
          email: 'invite@example.com',
        );

        final second = await endpoints.family.createInvite(
          owner,
          familyId: family.id,
          clientOperationId: 'family-invite-create-001',
          inviteType: 'link',
          email: 'different@example.com',
        );

        expect(second.id, first.id);
        expect(second.email, first.email);
        expect(second.token, first.token);
      },
    );
  });
}
