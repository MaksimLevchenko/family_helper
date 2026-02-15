import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Family idempotency', (sessionBuilder, endpoints) {
    test('createFamily returns the same family for duplicate operation id', () async {
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
    });
  });
}
