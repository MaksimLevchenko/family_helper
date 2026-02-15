import 'package:serverpod/serverpod.dart';

import '../auth/auth_context.dart';

class EnsureFamilyRoleService {
  const EnsureFamilyRoleService({this.authContext = const AuthContext()});

  final AuthContext authContext;

  Future<int> ensureFamilyRole(
    Session session, {
    required int familyId,
    required String minRole,
    Transaction? transaction,
  }) async {
    final profileId = await authContext.ensureProfileId(
      session,
      transaction: transaction,
    );

    final result = await session.db.unsafeQuery(
      '''
      SELECT role
      FROM family_member
      WHERE family_id = @familyId
        AND profile_id = @profileId
        AND status = 'active'
      LIMIT 1
      ''',
      parameters: QueryParameters.named({
        'familyId': familyId,
        'profileId': profileId,
      }),
      transaction: transaction,
    );

    if (result.isEmpty) {
      throw Exception('Access denied: not a family member');
    }

    final role = result.first.toColumnMap()['role'] as String;
    if (!_hasAccess(role: role, minRole: minRole)) {
      throw Exception('Access denied: role is insufficient');
    }

    return profileId;
  }

  bool _hasAccess({required String role, required String minRole}) {
    const rank = <String, int>{'member': 1, 'owner': 2};
    return (rank[role.toLowerCase()] ?? 0) >= (rank[minRole.toLowerCase()] ?? 0);
  }
}
