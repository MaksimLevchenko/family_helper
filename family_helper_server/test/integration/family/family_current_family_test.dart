import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Current family lookup', (sessionBuilder, endpoints) {
    test('returns the created family for the owner', () async {
      final owner = authenticatedBuilder(
        sessionBuilder,
        '10000000-0000-4000-8000-000000000001',
      );

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-current-owner-create-001',
        title: 'Current Family',
      );

      final currentFamily = await endpoints.family.getCurrentFamily(owner);

      expect(currentFamily?.id, family.id);
      expect(currentFamily?.title, family.title);
    });

    test('returns null when the user has no family', () async {
      final outsider = authenticatedBuilder(
        sessionBuilder,
        '10000000-0000-4000-8000-000000000002',
      );

      final currentFamily = await endpoints.family.getCurrentFamily(outsider);

      expect(currentFamily, isNull);
    });

    test('returns null after the member leaves the family', () async {
      final owner = authenticatedBuilder(
        sessionBuilder,
        '10000000-0000-4000-8000-000000000003',
      );
      final member = authenticatedBuilder(
        sessionBuilder,
        '10000000-0000-4000-8000-000000000004',
      );

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-current-leave-create-001',
        title: 'Temporary Family',
      );
      final invite = await endpoints.family.createInvite(
        owner,
        familyId: family.id,
        clientOperationId: 'family-current-leave-invite-001',
        inviteType: 'code',
      );

      await endpoints.family.acceptInvite(
        member,
        clientOperationId: 'family-current-leave-accept-001',
        tokenOrCode: invite.inviteCode,
      );
      await endpoints.family.leaveFamily(
        member,
        familyId: family.id,
        clientOperationId: 'family-current-leave-001',
      );

      final currentFamily = await endpoints.family.getCurrentFamily(member);

      expect(currentFamily, isNull);
    });
  });
}
