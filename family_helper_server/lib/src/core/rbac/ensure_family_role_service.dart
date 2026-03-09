import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../auth/auth_context.dart';
import '../../generated/protocol.dart';

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

    final membership = await FamilyMemberRow.db.findFirstRow(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.profileId.equals(profileId) &
          t.status.equals('active'),
      transaction: transaction,
    );

    if (membership == null) {
      throw AccessDeniedException(
        message: 'Access denied: not a family member.',
      );
    }

    final role = membership.role;
    if (!_hasAccess(role: role, minRole: minRole)) {
      throw AccessDeniedException(
        message: 'Access denied: role is insufficient.',
      );
    }

    return profileId;
  }

  bool _hasAccess({required String role, required String minRole}) {
    const rank = <String, int>{'member': 1, 'owner': 2};
    return (rank[role.toLowerCase()] ?? 0) >=
        (rank[minRole.toLowerCase()] ?? 0);
  }
}
