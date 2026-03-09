/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:family_helper_client/src/protocol/auth_profile/models/profile_dto.dart'
    as _i5;
import 'package:family_helper_client/src/protocol/calendar/models/calendar_event_dto.dart'
    as _i6;
import 'package:family_helper_client/src/protocol/core/models/operation_result.dart'
    as _i7;
import 'package:family_helper_client/src/protocol/calendar/models/calendar_instance_dto.dart'
    as _i8;
import 'package:family_helper_client/src/protocol/family/models/family_dto.dart'
    as _i9;
import 'package:family_helper_client/src/protocol/family/models/family_member_dto.dart'
    as _i10;
import 'package:family_helper_client/src/protocol/family/models/family_invite_dto.dart'
    as _i11;
import 'package:family_helper_client/src/protocol/greetings/greeting.dart'
    as _i12;
import 'package:family_helper_client/src/protocol/lists/models/family_list_dto.dart'
    as _i13;
import 'package:family_helper_client/src/protocol/lists/models/list_item_dto.dart'
    as _i14;
import 'package:family_helper_client/src/protocol/media/models/upload_session_dto.dart'
    as _i15;
import 'package:family_helper_client/src/protocol/media/models/media_object_dto.dart'
    as _i16;
import 'package:family_helper_client/src/protocol/money_goals/models/money_goal_dto.dart'
    as _i17;
import 'package:family_helper_client/src/protocol/money_goals/models/money_contribution_dto.dart'
    as _i18;
import 'package:family_helper_client/src/protocol/notifications/models/notification_preference_dto.dart'
    as _i19;
import 'package:family_helper_client/src/protocol/notifications/models/reminder_dto.dart'
    as _i20;
import 'package:family_helper_client/src/protocol/privacy/models/privacy_export_job_dto.dart'
    as _i21;
import 'package:family_helper_client/src/protocol/privacy/models/account_deletion_status_dto.dart'
    as _i22;
import 'package:family_helper_client/src/protocol/realtime/models/family_realtime_event.dart'
    as _i23;
import 'package:family_helper_client/src/protocol/sync/models/sync_changes_response.dart'
    as _i24;
import 'package:family_helper_client/src/protocol/tasks/models/task_dto.dart'
    as _i25;
import 'protocol.dart' as _i26;

/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointProfile extends _i2.EndpointRef {
  EndpointProfile(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  _i3.Future<_i5.ProfileDto> me() => caller.callServerEndpoint<_i5.ProfileDto>(
    'profile',
    'me',
    {},
  );

  _i3.Future<_i5.ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
  }) => caller.callServerEndpoint<_i5.ProfileDto>(
    'profile',
    'update',
    {
      'clientOperationId': clientOperationId,
      'displayName': displayName,
      'timezone': timezone,
      'avatarMediaId': avatarMediaId,
      'analyticsOptIn': analyticsOptIn,
    },
  );
}

/// {@category Endpoint}
class EndpointCalendar extends _i2.EndpointRef {
  EndpointCalendar(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'calendar';

  _i3.Future<_i6.CalendarEventDto> upsertEvent({
    required String clientOperationId,
    int? eventId,
    required int familyId,
    required String title,
    String? description,
    required DateTime startsAt,
    required DateTime endsAt,
    required String timezone,
    String? rrule,
    String? colorKey,
    String? category,
  }) => caller.callServerEndpoint<_i6.CalendarEventDto>(
    'calendar',
    'upsertEvent',
    {
      'clientOperationId': clientOperationId,
      'eventId': eventId,
      'familyId': familyId,
      'title': title,
      'description': description,
      'startsAt': startsAt,
      'endsAt': endsAt,
      'timezone': timezone,
      'rrule': rrule,
      'colorKey': colorKey,
      'category': category,
    },
  );

  _i3.Future<_i7.OperationResult> upsertOverride({
    required String clientOperationId,
    required int familyId,
    required int eventId,
    required DateTime occurrenceStart,
    required String scope,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    required bool cancelled,
  }) => caller.callServerEndpoint<_i7.OperationResult>(
    'calendar',
    'upsertOverride',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'eventId': eventId,
      'occurrenceStart': occurrenceStart,
      'scope': scope,
      'overrideTitle': overrideTitle,
      'overrideStartsAt': overrideStartsAt,
      'overrideEndsAt': overrideEndsAt,
      'cancelled': cancelled,
    },
  );

  _i3.Future<List<_i8.CalendarInstanceDto>> listInstances({
    required int familyId,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) => caller.callServerEndpoint<List<_i8.CalendarInstanceDto>>(
    'calendar',
    'listInstances',
    {
      'familyId': familyId,
      'rangeStart': rangeStart,
      'rangeEnd': rangeEnd,
    },
  );
}

/// {@category Endpoint}
class EndpointFamily extends _i2.EndpointRef {
  EndpointFamily(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'family';

  _i3.Future<_i9.FamilyDto> createFamily({
    required String clientOperationId,
    required String title,
  }) => caller.callServerEndpoint<_i9.FamilyDto>(
    'family',
    'createFamily',
    {
      'clientOperationId': clientOperationId,
      'title': title,
    },
  );

  _i3.Future<List<_i10.FamilyMemberDto>> listMembers({required int familyId}) =>
      caller.callServerEndpoint<List<_i10.FamilyMemberDto>>(
        'family',
        'listMembers',
        {'familyId': familyId},
      );

  _i3.Future<_i11.FamilyInviteDto> createInvite({
    required int familyId,
    required String clientOperationId,
    required String inviteType,
    String? email,
  }) => caller.callServerEndpoint<_i11.FamilyInviteDto>(
    'family',
    'createInvite',
    {
      'familyId': familyId,
      'clientOperationId': clientOperationId,
      'inviteType': inviteType,
      'email': email,
    },
  );

  _i3.Future<_i10.FamilyMemberDto> acceptInvite({
    required String clientOperationId,
    required String tokenOrCode,
  }) => caller.callServerEndpoint<_i10.FamilyMemberDto>(
    'family',
    'acceptInvite',
    {
      'clientOperationId': clientOperationId,
      'tokenOrCode': tokenOrCode,
    },
  );

  _i3.Future<_i7.OperationResult> transferOwnership({
    required int familyId,
    required String clientOperationId,
    required int newOwnerProfileId,
  }) => caller.callServerEndpoint<_i7.OperationResult>(
    'family',
    'transferOwnership',
    {
      'familyId': familyId,
      'clientOperationId': clientOperationId,
      'newOwnerProfileId': newOwnerProfileId,
    },
  );

  _i3.Future<_i7.OperationResult> leaveFamily({
    required int familyId,
    required String clientOperationId,
  }) => caller.callServerEndpoint<_i7.OperationResult>(
    'family',
    'leaveFamily',
    {
      'familyId': familyId,
      'clientOperationId': clientOperationId,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i12.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i12.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointLists extends _i2.EndpointRef {
  EndpointLists(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'lists';

  _i3.Future<_i13.FamilyListDto> upsertList({
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) => caller.callServerEndpoint<_i13.FamilyListDto>(
    'lists',
    'upsertList',
    {
      'clientOperationId': clientOperationId,
      'listId': listId,
      'familyId': familyId,
      'title': title,
      'listType': listType,
    },
  );

  _i3.Future<_i14.ListItemDto> addItem({
    required String clientOperationId,
    required int familyId,
    required int listId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
  }) => caller.callServerEndpoint<_i14.ListItemDto>(
    'lists',
    'addItem',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'listId': listId,
      'title': title,
      'qty': qty,
      'unit': unit,
      'note': note,
      'priceCents': priceCents,
      'category': category,
    },
  );

  _i3.Future<_i14.ListItemDto> toggleBought({
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) => caller.callServerEndpoint<_i14.ListItemDto>(
    'lists',
    'toggleBought',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'itemId': itemId,
    },
  );

  _i3.Future<_i7.OperationResult> reorderItems({
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) => caller.callServerEndpoint<_i7.OperationResult>(
    'lists',
    'reorderItems',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'listId': listId,
      'orderedItemIds': orderedItemIds,
    },
  );

  _i3.Future<List<_i14.ListItemDto>> listItems({
    required int familyId,
    required int listId,
  }) => caller.callServerEndpoint<List<_i14.ListItemDto>>(
    'lists',
    'listItems',
    {
      'familyId': familyId,
      'listId': listId,
    },
  );
}

/// {@category Endpoint}
class EndpointMedia extends _i2.EndpointRef {
  EndpointMedia(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'media';

  _i3.Future<_i15.UploadSessionDto> createUploadSession({
    required String clientOperationId,
    int? familyId,
    required String mimeType,
    required int sizeBytes,
    required String objectPrefix,
  }) => caller.callServerEndpoint<_i15.UploadSessionDto>(
    'media',
    'createUploadSession',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'objectPrefix': objectPrefix,
    },
  );

  _i3.Future<_i16.MediaObjectDto> completeUpload({
    required String clientOperationId,
    required int mediaId,
    String? thumbnailKey,
  }) => caller.callServerEndpoint<_i16.MediaObjectDto>(
    'media',
    'completeUpload',
    {
      'clientOperationId': clientOperationId,
      'mediaId': mediaId,
      'thumbnailKey': thumbnailKey,
    },
  );

  _i3.Future<String> signedGetUrl({required int mediaId}) =>
      caller.callServerEndpoint<String>(
        'media',
        'signedGetUrl',
        {'mediaId': mediaId},
      );

  _i3.Future<_i7.OperationResult> softDelete({
    required String clientOperationId,
    required int mediaId,
  }) => caller.callServerEndpoint<_i7.OperationResult>(
    'media',
    'softDelete',
    {
      'clientOperationId': clientOperationId,
      'mediaId': mediaId,
    },
  );
}

/// {@category Endpoint}
class EndpointMoneyGoals extends _i2.EndpointRef {
  EndpointMoneyGoals(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moneyGoals';

  _i3.Future<_i17.MoneyGoalDto> upsertGoal({
    required String clientOperationId,
    int? goalId,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    required String currency,
    DateTime? deadlineAt,
  }) => caller.callServerEndpoint<_i17.MoneyGoalDto>(
    'moneyGoals',
    'upsertGoal',
    {
      'clientOperationId': clientOperationId,
      'goalId': goalId,
      'familyId': familyId,
      'title': title,
      'description': description,
      'targetAmountCents': targetAmountCents,
      'currency': currency,
      'deadlineAt': deadlineAt,
    },
  );

  _i3.Future<_i18.MoneyContributionDto> addContribution({
    required String clientOperationId,
    required int familyId,
    required int goalId,
    required int amountCents,
    required String currency,
    String? note,
  }) => caller.callServerEndpoint<_i18.MoneyContributionDto>(
    'moneyGoals',
    'addContribution',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'goalId': goalId,
      'amountCents': amountCents,
      'currency': currency,
      'note': note,
    },
  );

  _i3.Future<List<_i17.MoneyGoalDto>> listGoals({required int familyId}) =>
      caller.callServerEndpoint<List<_i17.MoneyGoalDto>>(
        'moneyGoals',
        'listGoals',
        {'familyId': familyId},
      );
}

/// {@category Endpoint}
class EndpointNotifications extends _i2.EndpointRef {
  EndpointNotifications(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notifications';

  _i3.Future<_i7.OperationResult> registerPushToken({
    required String clientOperationId,
    required String token,
    required String platform,
  }) => caller.callServerEndpoint<_i7.OperationResult>(
    'notifications',
    'registerPushToken',
    {
      'clientOperationId': clientOperationId,
      'token': token,
      'platform': platform,
    },
  );

  _i3.Future<_i19.NotificationPreferenceDto> upsertPreference({
    required String clientOperationId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) => caller.callServerEndpoint<_i19.NotificationPreferenceDto>(
    'notifications',
    'upsertPreference',
    {
      'clientOperationId': clientOperationId,
      'notificationType': notificationType,
      'enabled': enabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    },
  );

  _i3.Future<_i20.ReminderDto> scheduleReminder({
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
  }) => caller.callServerEndpoint<_i20.ReminderDto>(
    'notifications',
    'scheduleReminder',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'entityType': entityType,
      'entityId': entityId,
      'remindAt': remindAt,
      'payloadJson': payloadJson,
    },
  );

  _i3.Future<int> processDueReminders() => caller.callServerEndpoint<int>(
    'notifications',
    'processDueReminders',
    {},
  );
}

/// {@category Endpoint}
class EndpointPrivacy extends _i2.EndpointRef {
  EndpointPrivacy(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privacy';

  _i3.Future<_i21.PrivacyExportJobDto> requestExport({
    required String clientOperationId,
  }) => caller.callServerEndpoint<_i21.PrivacyExportJobDto>(
    'privacy',
    'requestExport',
    {'clientOperationId': clientOperationId},
  );

  _i3.Future<_i22.AccountDeletionStatusDto> requestAccountDeletion({
    required String clientOperationId,
  }) => caller.callServerEndpoint<_i22.AccountDeletionStatusDto>(
    'privacy',
    'requestAccountDeletion',
    {'clientOperationId': clientOperationId},
  );

  _i3.Future<_i22.AccountDeletionStatusDto> cancelAccountDeletion() =>
      caller.callServerEndpoint<_i22.AccountDeletionStatusDto>(
        'privacy',
        'cancelAccountDeletion',
        {},
      );

  _i3.Future<int> processExportJobs() => caller.callServerEndpoint<int>(
    'privacy',
    'processExportJobs',
    {},
  );

  _i3.Future<int> processHardDeletion() => caller.callServerEndpoint<int>(
    'privacy',
    'processHardDeletion',
    {},
  );
}

/// {@category Endpoint}
class EndpointRealtime extends _i2.EndpointRef {
  EndpointRealtime(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'realtime';

  _i3.Stream<_i23.FamilyRealtimeEvent> watchFamilyEvents({
    required int familyId,
  }) =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i23.FamilyRealtimeEvent>,
        _i23.FamilyRealtimeEvent
      >(
        'realtime',
        'watchFamilyEvents',
        {'familyId': familyId},
        {},
      );
}

/// {@category Endpoint}
class EndpointSync extends _i2.EndpointRef {
  EndpointSync(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sync';

  _i3.Future<_i24.SyncChangesResponse> changes({
    required DateTime since,
    int? familyId,
    required int limit,
    required int lastSeenChangeId,
  }) => caller.callServerEndpoint<_i24.SyncChangesResponse>(
    'sync',
    'changes',
    {
      'since': since,
      'familyId': familyId,
      'limit': limit,
      'lastSeenChangeId': lastSeenChangeId,
    },
  );
}

/// {@category Endpoint}
class EndpointTasks extends _i2.EndpointRef {
  EndpointTasks(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tasks';

  _i3.Future<_i25.TaskDto> upsertTask({
    required String clientOperationId,
    int? taskId,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
  }) => caller.callServerEndpoint<_i25.TaskDto>(
    'tasks',
    'upsertTask',
    {
      'clientOperationId': clientOperationId,
      'taskId': taskId,
      'familyId': familyId,
      'title': title,
      'description': description,
      'isPersonal': isPersonal,
      'priority': priority,
      'dueAt': dueAt,
      'recurrenceMode': recurrenceMode,
      'recurrenceRrule': recurrenceRrule,
      'assigneeProfileId': assigneeProfileId,
    },
  );

  _i3.Future<List<_i25.TaskDto>> listTasks({required int familyId}) =>
      caller.callServerEndpoint<List<_i25.TaskDto>>(
        'tasks',
        'listTasks',
        {'familyId': familyId},
      );

  _i3.Future<_i25.TaskDto> completeTask({
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) => caller.callServerEndpoint<_i25.TaskDto>(
    'tasks',
    'completeTask',
    {
      'clientOperationId': clientOperationId,
      'familyId': familyId,
      'taskId': taskId,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i26.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    profile = EndpointProfile(this);
    calendar = EndpointCalendar(this);
    family = EndpointFamily(this);
    greeting = EndpointGreeting(this);
    lists = EndpointLists(this);
    media = EndpointMedia(this);
    moneyGoals = EndpointMoneyGoals(this);
    notifications = EndpointNotifications(this);
    privacy = EndpointPrivacy(this);
    realtime = EndpointRealtime(this);
    sync = EndpointSync(this);
    tasks = EndpointTasks(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointProfile profile;

  late final EndpointCalendar calendar;

  late final EndpointFamily family;

  late final EndpointGreeting greeting;

  late final EndpointLists lists;

  late final EndpointMedia media;

  late final EndpointMoneyGoals moneyGoals;

  late final EndpointNotifications notifications;

  late final EndpointPrivacy privacy;

  late final EndpointRealtime realtime;

  late final EndpointSync sync;

  late final EndpointTasks tasks;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'profile': profile,
    'calendar': calendar,
    'family': family,
    'greeting': greeting,
    'lists': lists,
    'media': media,
    'moneyGoals': moneyGoals,
    'notifications': notifications,
    'privacy': privacy,
    'realtime': realtime,
    'sync': sync,
    'tasks': tasks,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
