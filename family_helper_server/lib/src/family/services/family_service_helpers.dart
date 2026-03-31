part of 'family_service.dart';

Future<FamilyDto> _findFamily(
  FamilyService service,
  Session session,
  int familyId, {
  Transaction? transaction,
}) async {
  final row = await FamilyRow.db.findById(
    session,
    familyId,
    transaction: transaction,
  );
  return _mapFamily(row!);
}

Future<FamilyInviteDto> _findInvite(
  FamilyService service,
  Session session,
  int inviteId, {
  Transaction? transaction,
}) async {
  final row = await FamilyInviteRow.db.findById(
    session,
    inviteId,
    transaction: transaction,
  );
  return _mapInvite(row!);
}

Future<FamilyMemberDto> _findMember(
  FamilyService service,
  Session session,
  int memberId, {
  Transaction? transaction,
}) async {
  final row = await FamilyMemberRow.db.findById(
    session,
    memberId,
    transaction: transaction,
  );
  final profile = row == null
      ? null
      : await AppProfileRow.db.findById(
          session,
          row.profileId,
          transaction: transaction,
        );
  return _mapMember(row!, profile);
}

FamilyDto _mapFamily(FamilyRow row) {
  return FamilyDto(
    id: row.id!,
    title: row.title,
    ownerProfileId: row.ownerProfileId,
    memberLimit: row.memberLimit,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

FamilyMemberDto _mapMember(FamilyMemberRow row, AppProfileRow? profile) {
  return FamilyMemberDto(
    id: row.id!,
    familyId: row.familyId,
    profileId: row.profileId,
    displayName: profile?.displayName ?? 'User #${row.profileId}',
    avatarMediaId: profile?.avatarMediaId,
    role: row.role,
    status: row.status,
    createdAt: row.createdAt,
  );
}

FamilyInviteDto _mapInvite(FamilyInviteRow row) {
  return FamilyInviteDto(
    id: row.id!,
    familyId: row.familyId,
    inviteType: row.inviteType,
    email: row.email,
    inviteCode: row.inviteCode,
    token: row.token,
    expiresAt: row.expiresAt,
    acceptedAt: row.acceptedAt,
    createdAt: row.createdAt,
  );
}

String _randomCode(int length) {
  const alphabet =
      'ABCDEFGHJKLMNPQRSTUVWXYZ23456789abcdefghijkmnopqrstuvwxyz';
  final random = Random.secure();
  return List<String>.generate(
    length,
    (_) => alphabet[random.nextInt(alphabet.length)],
  ).join();
}

String? _normalizeInviteEmail({
  required String inviteType,
  required String? email,
}) {
  if (inviteType == 'email') {
    final normalized = email?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      throw ArgumentError.value(
        email,
        'email',
        'Email is required for email invites.',
      );
    }
    return normalized;
  }

  return null;
}

Future<void> _ensureInviteRecipientMatches(
  FamilyService service,
  Session session, {
  required FamilyInviteRow invite,
  Transaction? transaction,
}) async {
  if (invite.inviteType != 'email') {
    return;
  }

  final normalizedInviteEmail = invite.email?.trim().toLowerCase();
  if (normalizedInviteEmail == null || normalizedInviteEmail.isEmpty) {
    throw AccessDeniedException(message: 'Invite is invalid.');
  }

  final authUserId = service.authContext.requireAuthUserId(session);
  final account = await EmailAccount.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(authUserId),
    transaction: transaction,
  );
  final normalizedAccountEmail = account?.email.trim().toLowerCase();
  if (normalizedAccountEmail != normalizedInviteEmail) {
    throw AccessDeniedException(message: 'Invite is not available.');
  }
}
