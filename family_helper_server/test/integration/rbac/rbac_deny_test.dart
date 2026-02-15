import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('RBAC deny', (sessionBuilder, endpoints) {
    test('non-member cannot read family members', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final outsider = authenticatedBuilder(sessionBuilder, user2Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-rbac-001',
        title: 'Private Family',
      );

      expect(
        () => endpoints.family.listMembers(outsider, familyId: family.id),
        throwsA(isA<Exception>()),
      );
    });
  });
}
