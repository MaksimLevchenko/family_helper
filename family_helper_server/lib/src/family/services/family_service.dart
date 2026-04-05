import 'dart:io';
import 'dart:math';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';
import '../../notifications/services/app_notification_service.dart';
import '../../notifications/services/notification_message_builder.dart';
import 'family_invite_email_dispatcher.dart';

part 'family_service_helpers.dart';
part 'family_service_invites.dart';
part 'family_service_lifecycle.dart';
part 'family_service_membership.dart';

class FamilyService {
  FamilyService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
    this.audit = const AuditService(),
    AppNotificationService? appNotifications,
  }) : appNotifications = appNotifications ?? AppNotificationService();

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;
  final AuditService audit;
  final AppNotificationService appNotifications;

  Future<FamilyDto> createFamily(
    Session session, {
    required String clientOperationId,
    required String title,
  }) {
    return _createFamilyImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      title: title,
    );
  }

  Future<List<FamilyMemberDto>> listMembers(
    Session session, {
    required int familyId,
  }) {
    return _listMembersImpl(this, session, familyId: familyId);
  }

  Future<FamilyDto?> getCurrentFamily(Session session) {
    return _getCurrentFamilyImpl(this, session);
  }

  Future<FamilyDto> getFamily(
    Session session, {
    required int familyId,
  }) {
    return _getFamilyImpl(this, session, familyId: familyId);
  }

  Future<FamilyDto> renameFamily(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required String title,
  }) {
    return _renameFamilyImpl(
      this,
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
      title: title,
    );
  }

  Future<FamilyInviteDto> createInvite(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required String inviteType,
    String? email,
  }) {
    return _createInviteImpl(
      this,
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
      inviteType: inviteType,
      email: email,
    );
  }

  Future<FamilyMemberDto> acceptInvite(
    Session session, {
    required String clientOperationId,
    required String tokenOrCode,
  }) {
    return _acceptInviteImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      tokenOrCode: tokenOrCode,
    );
  }

  Future<OperationResult> transferOwnership(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required int newOwnerProfileId,
  }) {
    return _transferOwnershipImpl(
      this,
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
      newOwnerProfileId: newOwnerProfileId,
    );
  }

  Future<OperationResult> leaveFamily(
    Session session, {
    required int familyId,
    required String clientOperationId,
  }) {
    return _leaveFamilyImpl(
      this,
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
    );
  }
}
