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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'auth_profile/models/profile_dto.dart' as _i2;
import 'calendar/models/calendar_event_dto.dart' as _i3;
import 'calendar/models/calendar_event_override_row.dart' as _i4;
import 'calendar/models/calendar_event_row.dart' as _i5;
import 'calendar/models/calendar_instance_dto.dart' as _i6;
import 'core/models/api_error_dto.dart' as _i7;
import 'core/models/app_profile_row.dart' as _i8;
import 'core/models/audit_log_row.dart' as _i9;
import 'core/models/change_feed_row.dart' as _i10;
import 'core/models/idempotency_key_row.dart' as _i11;
import 'core/models/mutation_meta.dart' as _i12;
import 'core/models/operation_result.dart' as _i13;
import 'core/models/paged_request.dart' as _i14;
import 'core/models/security_event_row.dart' as _i15;
import 'family/models/family_dto.dart' as _i16;
import 'family/models/family_invite_dto.dart' as _i17;
import 'family/models/family_invite_row.dart' as _i18;
import 'family/models/family_member_dto.dart' as _i19;
import 'family/models/family_member_row.dart' as _i20;
import 'family/models/family_row.dart' as _i21;
import 'greetings/greeting.dart' as _i22;
import 'lists/models/family_list_dto.dart' as _i23;
import 'lists/models/family_list_row.dart' as _i24;
import 'lists/models/list_item_dto.dart' as _i25;
import 'lists/models/list_item_history_row.dart' as _i26;
import 'lists/models/list_item_row.dart' as _i27;
import 'media/models/media_attachment_row.dart' as _i28;
import 'media/models/media_object_dto.dart' as _i29;
import 'media/models/media_object_row.dart' as _i30;
import 'media/models/upload_session_dto.dart' as _i31;
import 'money_goals/models/money_contribution_dto.dart' as _i32;
import 'money_goals/models/money_contribution_row.dart' as _i33;
import 'money_goals/models/money_goal_dto.dart' as _i34;
import 'money_goals/models/money_goal_row.dart' as _i35;
import 'notifications/models/notification_preference_dto.dart' as _i36;
import 'notifications/models/notification_preference_row.dart' as _i37;
import 'notifications/models/push_token_row.dart' as _i38;
import 'notifications/models/reminder_dto.dart' as _i39;
import 'notifications/models/reminder_row.dart' as _i40;
import 'privacy/models/account_deletion_request_row.dart' as _i41;
import 'privacy/models/account_deletion_status_dto.dart' as _i42;
import 'privacy/models/privacy_export_job_dto.dart' as _i43;
import 'privacy/models/privacy_export_job_row.dart' as _i44;
import 'privacy/models/privacy_status_dto.dart' as _i45;
import 'realtime/models/family_realtime_event.dart' as _i46;
import 'sync/models/sync_change_dto.dart' as _i47;
import 'sync/models/sync_changes_response.dart' as _i48;
import 'tasks/models/task_dto.dart' as _i49;
import 'tasks/models/task_history_row.dart' as _i50;
import 'tasks/models/task_row.dart' as _i51;
import 'workers/models/account_deletion_payload.dart' as _i52;
import 'workers/models/media_cleanup_payload.dart' as _i53;
import 'workers/models/notifications_due_payload.dart' as _i54;
import 'workers/models/privacy_export_payload.dart' as _i55;
import 'package:family_helper_client/src/protocol/calendar/models/calendar_instance_dto.dart'
    as _i56;
import 'package:family_helper_client/src/protocol/family/models/family_member_dto.dart'
    as _i57;
import 'package:family_helper_client/src/protocol/lists/models/list_item_dto.dart'
    as _i58;
import 'package:family_helper_client/src/protocol/media/models/media_object_dto.dart'
    as _i59;
import 'package:family_helper_client/src/protocol/money_goals/models/money_goal_dto.dart'
    as _i60;
import 'package:family_helper_client/src/protocol/notifications/models/reminder_dto.dart'
    as _i61;
import 'package:family_helper_client/src/protocol/tasks/models/task_dto.dart'
    as _i62;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i63;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i64;
export 'auth_profile/models/profile_dto.dart';
export 'calendar/models/calendar_event_dto.dart';
export 'calendar/models/calendar_event_override_row.dart';
export 'calendar/models/calendar_event_row.dart';
export 'calendar/models/calendar_instance_dto.dart';
export 'core/models/api_error_dto.dart';
export 'core/models/app_profile_row.dart';
export 'core/models/audit_log_row.dart';
export 'core/models/change_feed_row.dart';
export 'core/models/idempotency_key_row.dart';
export 'core/models/mutation_meta.dart';
export 'core/models/operation_result.dart';
export 'core/models/paged_request.dart';
export 'core/models/security_event_row.dart';
export 'family/models/family_dto.dart';
export 'family/models/family_invite_dto.dart';
export 'family/models/family_invite_row.dart';
export 'family/models/family_member_dto.dart';
export 'family/models/family_member_row.dart';
export 'family/models/family_row.dart';
export 'greetings/greeting.dart';
export 'lists/models/family_list_dto.dart';
export 'lists/models/family_list_row.dart';
export 'lists/models/list_item_dto.dart';
export 'lists/models/list_item_history_row.dart';
export 'lists/models/list_item_row.dart';
export 'media/models/media_attachment_row.dart';
export 'media/models/media_object_dto.dart';
export 'media/models/media_object_row.dart';
export 'media/models/upload_session_dto.dart';
export 'money_goals/models/money_contribution_dto.dart';
export 'money_goals/models/money_contribution_row.dart';
export 'money_goals/models/money_goal_dto.dart';
export 'money_goals/models/money_goal_row.dart';
export 'notifications/models/notification_preference_dto.dart';
export 'notifications/models/notification_preference_row.dart';
export 'notifications/models/push_token_row.dart';
export 'notifications/models/reminder_dto.dart';
export 'notifications/models/reminder_row.dart';
export 'privacy/models/account_deletion_request_row.dart';
export 'privacy/models/account_deletion_status_dto.dart';
export 'privacy/models/privacy_export_job_dto.dart';
export 'privacy/models/privacy_export_job_row.dart';
export 'privacy/models/privacy_status_dto.dart';
export 'realtime/models/family_realtime_event.dart';
export 'sync/models/sync_change_dto.dart';
export 'sync/models/sync_changes_response.dart';
export 'tasks/models/task_dto.dart';
export 'tasks/models/task_history_row.dart';
export 'tasks/models/task_row.dart';
export 'workers/models/account_deletion_payload.dart';
export 'workers/models/media_cleanup_payload.dart';
export 'workers/models/notifications_due_payload.dart';
export 'workers/models/privacy_export_payload.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ProfileDto) {
      return _i2.ProfileDto.fromJson(data) as T;
    }
    if (t == _i3.CalendarEventDto) {
      return _i3.CalendarEventDto.fromJson(data) as T;
    }
    if (t == _i4.CalendarEventOverrideRow) {
      return _i4.CalendarEventOverrideRow.fromJson(data) as T;
    }
    if (t == _i5.CalendarEventRow) {
      return _i5.CalendarEventRow.fromJson(data) as T;
    }
    if (t == _i6.CalendarInstanceDto) {
      return _i6.CalendarInstanceDto.fromJson(data) as T;
    }
    if (t == _i7.ApiErrorDto) {
      return _i7.ApiErrorDto.fromJson(data) as T;
    }
    if (t == _i8.AppProfileRow) {
      return _i8.AppProfileRow.fromJson(data) as T;
    }
    if (t == _i9.AuditLogRow) {
      return _i9.AuditLogRow.fromJson(data) as T;
    }
    if (t == _i10.ChangeFeedRow) {
      return _i10.ChangeFeedRow.fromJson(data) as T;
    }
    if (t == _i11.IdempotencyKeyRow) {
      return _i11.IdempotencyKeyRow.fromJson(data) as T;
    }
    if (t == _i12.MutationMeta) {
      return _i12.MutationMeta.fromJson(data) as T;
    }
    if (t == _i13.OperationResult) {
      return _i13.OperationResult.fromJson(data) as T;
    }
    if (t == _i14.PagedRequest) {
      return _i14.PagedRequest.fromJson(data) as T;
    }
    if (t == _i15.SecurityEventRow) {
      return _i15.SecurityEventRow.fromJson(data) as T;
    }
    if (t == _i16.FamilyDto) {
      return _i16.FamilyDto.fromJson(data) as T;
    }
    if (t == _i17.FamilyInviteDto) {
      return _i17.FamilyInviteDto.fromJson(data) as T;
    }
    if (t == _i18.FamilyInviteRow) {
      return _i18.FamilyInviteRow.fromJson(data) as T;
    }
    if (t == _i19.FamilyMemberDto) {
      return _i19.FamilyMemberDto.fromJson(data) as T;
    }
    if (t == _i20.FamilyMemberRow) {
      return _i20.FamilyMemberRow.fromJson(data) as T;
    }
    if (t == _i21.FamilyRow) {
      return _i21.FamilyRow.fromJson(data) as T;
    }
    if (t == _i22.Greeting) {
      return _i22.Greeting.fromJson(data) as T;
    }
    if (t == _i23.FamilyListDto) {
      return _i23.FamilyListDto.fromJson(data) as T;
    }
    if (t == _i24.FamilyListRow) {
      return _i24.FamilyListRow.fromJson(data) as T;
    }
    if (t == _i25.ListItemDto) {
      return _i25.ListItemDto.fromJson(data) as T;
    }
    if (t == _i26.ListItemHistoryRow) {
      return _i26.ListItemHistoryRow.fromJson(data) as T;
    }
    if (t == _i27.ListItemRow) {
      return _i27.ListItemRow.fromJson(data) as T;
    }
    if (t == _i28.MediaAttachmentRow) {
      return _i28.MediaAttachmentRow.fromJson(data) as T;
    }
    if (t == _i29.MediaObjectDto) {
      return _i29.MediaObjectDto.fromJson(data) as T;
    }
    if (t == _i30.MediaObjectRow) {
      return _i30.MediaObjectRow.fromJson(data) as T;
    }
    if (t == _i31.UploadSessionDto) {
      return _i31.UploadSessionDto.fromJson(data) as T;
    }
    if (t == _i32.MoneyContributionDto) {
      return _i32.MoneyContributionDto.fromJson(data) as T;
    }
    if (t == _i33.MoneyContributionRow) {
      return _i33.MoneyContributionRow.fromJson(data) as T;
    }
    if (t == _i34.MoneyGoalDto) {
      return _i34.MoneyGoalDto.fromJson(data) as T;
    }
    if (t == _i35.MoneyGoalRow) {
      return _i35.MoneyGoalRow.fromJson(data) as T;
    }
    if (t == _i36.NotificationPreferenceDto) {
      return _i36.NotificationPreferenceDto.fromJson(data) as T;
    }
    if (t == _i37.NotificationPreferenceRow) {
      return _i37.NotificationPreferenceRow.fromJson(data) as T;
    }
    if (t == _i38.PushTokenRow) {
      return _i38.PushTokenRow.fromJson(data) as T;
    }
    if (t == _i39.ReminderDto) {
      return _i39.ReminderDto.fromJson(data) as T;
    }
    if (t == _i40.ReminderRow) {
      return _i40.ReminderRow.fromJson(data) as T;
    }
    if (t == _i41.AccountDeletionRequestRow) {
      return _i41.AccountDeletionRequestRow.fromJson(data) as T;
    }
    if (t == _i42.AccountDeletionStatusDto) {
      return _i42.AccountDeletionStatusDto.fromJson(data) as T;
    }
    if (t == _i43.PrivacyExportJobDto) {
      return _i43.PrivacyExportJobDto.fromJson(data) as T;
    }
    if (t == _i44.PrivacyExportJobRow) {
      return _i44.PrivacyExportJobRow.fromJson(data) as T;
    }
    if (t == _i45.PrivacyStatusDto) {
      return _i45.PrivacyStatusDto.fromJson(data) as T;
    }
    if (t == _i46.FamilyRealtimeEvent) {
      return _i46.FamilyRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i47.SyncChangeDto) {
      return _i47.SyncChangeDto.fromJson(data) as T;
    }
    if (t == _i48.SyncChangesResponse) {
      return _i48.SyncChangesResponse.fromJson(data) as T;
    }
    if (t == _i49.TaskDto) {
      return _i49.TaskDto.fromJson(data) as T;
    }
    if (t == _i50.TaskHistoryRow) {
      return _i50.TaskHistoryRow.fromJson(data) as T;
    }
    if (t == _i51.TaskRow) {
      return _i51.TaskRow.fromJson(data) as T;
    }
    if (t == _i52.AccountDeletionPayload) {
      return _i52.AccountDeletionPayload.fromJson(data) as T;
    }
    if (t == _i53.MediaCleanupPayload) {
      return _i53.MediaCleanupPayload.fromJson(data) as T;
    }
    if (t == _i54.NotificationsDuePayload) {
      return _i54.NotificationsDuePayload.fromJson(data) as T;
    }
    if (t == _i55.PrivacyExportPayload) {
      return _i55.PrivacyExportPayload.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ProfileDto?>()) {
      return (data != null ? _i2.ProfileDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CalendarEventDto?>()) {
      return (data != null ? _i3.CalendarEventDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CalendarEventOverrideRow?>()) {
      return (data != null ? _i4.CalendarEventOverrideRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.CalendarEventRow?>()) {
      return (data != null ? _i5.CalendarEventRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CalendarInstanceDto?>()) {
      return (data != null ? _i6.CalendarInstanceDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.ApiErrorDto?>()) {
      return (data != null ? _i7.ApiErrorDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AppProfileRow?>()) {
      return (data != null ? _i8.AppProfileRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AuditLogRow?>()) {
      return (data != null ? _i9.AuditLogRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ChangeFeedRow?>()) {
      return (data != null ? _i10.ChangeFeedRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.IdempotencyKeyRow?>()) {
      return (data != null ? _i11.IdempotencyKeyRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.MutationMeta?>()) {
      return (data != null ? _i12.MutationMeta.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.OperationResult?>()) {
      return (data != null ? _i13.OperationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.PagedRequest?>()) {
      return (data != null ? _i14.PagedRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.SecurityEventRow?>()) {
      return (data != null ? _i15.SecurityEventRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.FamilyDto?>()) {
      return (data != null ? _i16.FamilyDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.FamilyInviteDto?>()) {
      return (data != null ? _i17.FamilyInviteDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.FamilyInviteRow?>()) {
      return (data != null ? _i18.FamilyInviteRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.FamilyMemberDto?>()) {
      return (data != null ? _i19.FamilyMemberDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.FamilyMemberRow?>()) {
      return (data != null ? _i20.FamilyMemberRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.FamilyRow?>()) {
      return (data != null ? _i21.FamilyRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Greeting?>()) {
      return (data != null ? _i22.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.FamilyListDto?>()) {
      return (data != null ? _i23.FamilyListDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.FamilyListRow?>()) {
      return (data != null ? _i24.FamilyListRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ListItemDto?>()) {
      return (data != null ? _i25.ListItemDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ListItemHistoryRow?>()) {
      return (data != null ? _i26.ListItemHistoryRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.ListItemRow?>()) {
      return (data != null ? _i27.ListItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.MediaAttachmentRow?>()) {
      return (data != null ? _i28.MediaAttachmentRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.MediaObjectDto?>()) {
      return (data != null ? _i29.MediaObjectDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.MediaObjectRow?>()) {
      return (data != null ? _i30.MediaObjectRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.UploadSessionDto?>()) {
      return (data != null ? _i31.UploadSessionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.MoneyContributionDto?>()) {
      return (data != null ? _i32.MoneyContributionDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.MoneyContributionRow?>()) {
      return (data != null ? _i33.MoneyContributionRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.MoneyGoalDto?>()) {
      return (data != null ? _i34.MoneyGoalDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.MoneyGoalRow?>()) {
      return (data != null ? _i35.MoneyGoalRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.NotificationPreferenceDto?>()) {
      return (data != null
              ? _i36.NotificationPreferenceDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i37.NotificationPreferenceRow?>()) {
      return (data != null
              ? _i37.NotificationPreferenceRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i38.PushTokenRow?>()) {
      return (data != null ? _i38.PushTokenRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.ReminderDto?>()) {
      return (data != null ? _i39.ReminderDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.ReminderRow?>()) {
      return (data != null ? _i40.ReminderRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.AccountDeletionRequestRow?>()) {
      return (data != null
              ? _i41.AccountDeletionRequestRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i42.AccountDeletionStatusDto?>()) {
      return (data != null
              ? _i42.AccountDeletionStatusDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i43.PrivacyExportJobDto?>()) {
      return (data != null ? _i43.PrivacyExportJobDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.PrivacyExportJobRow?>()) {
      return (data != null ? _i44.PrivacyExportJobRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.PrivacyStatusDto?>()) {
      return (data != null ? _i45.PrivacyStatusDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.FamilyRealtimeEvent?>()) {
      return (data != null ? _i46.FamilyRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.SyncChangeDto?>()) {
      return (data != null ? _i47.SyncChangeDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.SyncChangesResponse?>()) {
      return (data != null ? _i48.SyncChangesResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.TaskDto?>()) {
      return (data != null ? _i49.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.TaskHistoryRow?>()) {
      return (data != null ? _i50.TaskHistoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.TaskRow?>()) {
      return (data != null ? _i51.TaskRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.AccountDeletionPayload?>()) {
      return (data != null ? _i52.AccountDeletionPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.MediaCleanupPayload?>()) {
      return (data != null ? _i53.MediaCleanupPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.NotificationsDuePayload?>()) {
      return (data != null ? _i54.NotificationsDuePayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.PrivacyExportPayload?>()) {
      return (data != null ? _i55.PrivacyExportPayload.fromJson(data) : null)
          as T;
    }
    if (t == List<_i47.SyncChangeDto>) {
      return (data as List)
              .map((e) => deserialize<_i47.SyncChangeDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i56.CalendarInstanceDto>) {
      return (data as List)
              .map((e) => deserialize<_i56.CalendarInstanceDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.FamilyMemberDto>) {
      return (data as List)
              .map((e) => deserialize<_i57.FamilyMemberDto>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i58.ListItemDto>) {
      return (data as List)
              .map((e) => deserialize<_i58.ListItemDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i59.MediaObjectDto>) {
      return (data as List)
              .map((e) => deserialize<_i59.MediaObjectDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.MoneyGoalDto>) {
      return (data as List)
              .map((e) => deserialize<_i60.MoneyGoalDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i61.ReminderDto>) {
      return (data as List)
              .map((e) => deserialize<_i61.ReminderDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.TaskDto>) {
      return (data as List).map((e) => deserialize<_i62.TaskDto>(e)).toList()
          as T;
    }
    try {
      return _i63.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i64.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ProfileDto => 'ProfileDto',
      _i3.CalendarEventDto => 'CalendarEventDto',
      _i4.CalendarEventOverrideRow => 'CalendarEventOverrideRow',
      _i5.CalendarEventRow => 'CalendarEventRow',
      _i6.CalendarInstanceDto => 'CalendarInstanceDto',
      _i7.ApiErrorDto => 'ApiErrorDto',
      _i8.AppProfileRow => 'AppProfileRow',
      _i9.AuditLogRow => 'AuditLogRow',
      _i10.ChangeFeedRow => 'ChangeFeedRow',
      _i11.IdempotencyKeyRow => 'IdempotencyKeyRow',
      _i12.MutationMeta => 'MutationMeta',
      _i13.OperationResult => 'OperationResult',
      _i14.PagedRequest => 'PagedRequest',
      _i15.SecurityEventRow => 'SecurityEventRow',
      _i16.FamilyDto => 'FamilyDto',
      _i17.FamilyInviteDto => 'FamilyInviteDto',
      _i18.FamilyInviteRow => 'FamilyInviteRow',
      _i19.FamilyMemberDto => 'FamilyMemberDto',
      _i20.FamilyMemberRow => 'FamilyMemberRow',
      _i21.FamilyRow => 'FamilyRow',
      _i22.Greeting => 'Greeting',
      _i23.FamilyListDto => 'FamilyListDto',
      _i24.FamilyListRow => 'FamilyListRow',
      _i25.ListItemDto => 'ListItemDto',
      _i26.ListItemHistoryRow => 'ListItemHistoryRow',
      _i27.ListItemRow => 'ListItemRow',
      _i28.MediaAttachmentRow => 'MediaAttachmentRow',
      _i29.MediaObjectDto => 'MediaObjectDto',
      _i30.MediaObjectRow => 'MediaObjectRow',
      _i31.UploadSessionDto => 'UploadSessionDto',
      _i32.MoneyContributionDto => 'MoneyContributionDto',
      _i33.MoneyContributionRow => 'MoneyContributionRow',
      _i34.MoneyGoalDto => 'MoneyGoalDto',
      _i35.MoneyGoalRow => 'MoneyGoalRow',
      _i36.NotificationPreferenceDto => 'NotificationPreferenceDto',
      _i37.NotificationPreferenceRow => 'NotificationPreferenceRow',
      _i38.PushTokenRow => 'PushTokenRow',
      _i39.ReminderDto => 'ReminderDto',
      _i40.ReminderRow => 'ReminderRow',
      _i41.AccountDeletionRequestRow => 'AccountDeletionRequestRow',
      _i42.AccountDeletionStatusDto => 'AccountDeletionStatusDto',
      _i43.PrivacyExportJobDto => 'PrivacyExportJobDto',
      _i44.PrivacyExportJobRow => 'PrivacyExportJobRow',
      _i45.PrivacyStatusDto => 'PrivacyStatusDto',
      _i46.FamilyRealtimeEvent => 'FamilyRealtimeEvent',
      _i47.SyncChangeDto => 'SyncChangeDto',
      _i48.SyncChangesResponse => 'SyncChangesResponse',
      _i49.TaskDto => 'TaskDto',
      _i50.TaskHistoryRow => 'TaskHistoryRow',
      _i51.TaskRow => 'TaskRow',
      _i52.AccountDeletionPayload => 'AccountDeletionPayload',
      _i53.MediaCleanupPayload => 'MediaCleanupPayload',
      _i54.NotificationsDuePayload => 'NotificationsDuePayload',
      _i55.PrivacyExportPayload => 'PrivacyExportPayload',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'family_helper.',
        '',
      );
    }

    switch (data) {
      case _i2.ProfileDto():
        return 'ProfileDto';
      case _i3.CalendarEventDto():
        return 'CalendarEventDto';
      case _i4.CalendarEventOverrideRow():
        return 'CalendarEventOverrideRow';
      case _i5.CalendarEventRow():
        return 'CalendarEventRow';
      case _i6.CalendarInstanceDto():
        return 'CalendarInstanceDto';
      case _i7.ApiErrorDto():
        return 'ApiErrorDto';
      case _i8.AppProfileRow():
        return 'AppProfileRow';
      case _i9.AuditLogRow():
        return 'AuditLogRow';
      case _i10.ChangeFeedRow():
        return 'ChangeFeedRow';
      case _i11.IdempotencyKeyRow():
        return 'IdempotencyKeyRow';
      case _i12.MutationMeta():
        return 'MutationMeta';
      case _i13.OperationResult():
        return 'OperationResult';
      case _i14.PagedRequest():
        return 'PagedRequest';
      case _i15.SecurityEventRow():
        return 'SecurityEventRow';
      case _i16.FamilyDto():
        return 'FamilyDto';
      case _i17.FamilyInviteDto():
        return 'FamilyInviteDto';
      case _i18.FamilyInviteRow():
        return 'FamilyInviteRow';
      case _i19.FamilyMemberDto():
        return 'FamilyMemberDto';
      case _i20.FamilyMemberRow():
        return 'FamilyMemberRow';
      case _i21.FamilyRow():
        return 'FamilyRow';
      case _i22.Greeting():
        return 'Greeting';
      case _i23.FamilyListDto():
        return 'FamilyListDto';
      case _i24.FamilyListRow():
        return 'FamilyListRow';
      case _i25.ListItemDto():
        return 'ListItemDto';
      case _i26.ListItemHistoryRow():
        return 'ListItemHistoryRow';
      case _i27.ListItemRow():
        return 'ListItemRow';
      case _i28.MediaAttachmentRow():
        return 'MediaAttachmentRow';
      case _i29.MediaObjectDto():
        return 'MediaObjectDto';
      case _i30.MediaObjectRow():
        return 'MediaObjectRow';
      case _i31.UploadSessionDto():
        return 'UploadSessionDto';
      case _i32.MoneyContributionDto():
        return 'MoneyContributionDto';
      case _i33.MoneyContributionRow():
        return 'MoneyContributionRow';
      case _i34.MoneyGoalDto():
        return 'MoneyGoalDto';
      case _i35.MoneyGoalRow():
        return 'MoneyGoalRow';
      case _i36.NotificationPreferenceDto():
        return 'NotificationPreferenceDto';
      case _i37.NotificationPreferenceRow():
        return 'NotificationPreferenceRow';
      case _i38.PushTokenRow():
        return 'PushTokenRow';
      case _i39.ReminderDto():
        return 'ReminderDto';
      case _i40.ReminderRow():
        return 'ReminderRow';
      case _i41.AccountDeletionRequestRow():
        return 'AccountDeletionRequestRow';
      case _i42.AccountDeletionStatusDto():
        return 'AccountDeletionStatusDto';
      case _i43.PrivacyExportJobDto():
        return 'PrivacyExportJobDto';
      case _i44.PrivacyExportJobRow():
        return 'PrivacyExportJobRow';
      case _i45.PrivacyStatusDto():
        return 'PrivacyStatusDto';
      case _i46.FamilyRealtimeEvent():
        return 'FamilyRealtimeEvent';
      case _i47.SyncChangeDto():
        return 'SyncChangeDto';
      case _i48.SyncChangesResponse():
        return 'SyncChangesResponse';
      case _i49.TaskDto():
        return 'TaskDto';
      case _i50.TaskHistoryRow():
        return 'TaskHistoryRow';
      case _i51.TaskRow():
        return 'TaskRow';
      case _i52.AccountDeletionPayload():
        return 'AccountDeletionPayload';
      case _i53.MediaCleanupPayload():
        return 'MediaCleanupPayload';
      case _i54.NotificationsDuePayload():
        return 'NotificationsDuePayload';
      case _i55.PrivacyExportPayload():
        return 'PrivacyExportPayload';
    }
    className = _i63.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i64.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ProfileDto') {
      return deserialize<_i2.ProfileDto>(data['data']);
    }
    if (dataClassName == 'CalendarEventDto') {
      return deserialize<_i3.CalendarEventDto>(data['data']);
    }
    if (dataClassName == 'CalendarEventOverrideRow') {
      return deserialize<_i4.CalendarEventOverrideRow>(data['data']);
    }
    if (dataClassName == 'CalendarEventRow') {
      return deserialize<_i5.CalendarEventRow>(data['data']);
    }
    if (dataClassName == 'CalendarInstanceDto') {
      return deserialize<_i6.CalendarInstanceDto>(data['data']);
    }
    if (dataClassName == 'ApiErrorDto') {
      return deserialize<_i7.ApiErrorDto>(data['data']);
    }
    if (dataClassName == 'AppProfileRow') {
      return deserialize<_i8.AppProfileRow>(data['data']);
    }
    if (dataClassName == 'AuditLogRow') {
      return deserialize<_i9.AuditLogRow>(data['data']);
    }
    if (dataClassName == 'ChangeFeedRow') {
      return deserialize<_i10.ChangeFeedRow>(data['data']);
    }
    if (dataClassName == 'IdempotencyKeyRow') {
      return deserialize<_i11.IdempotencyKeyRow>(data['data']);
    }
    if (dataClassName == 'MutationMeta') {
      return deserialize<_i12.MutationMeta>(data['data']);
    }
    if (dataClassName == 'OperationResult') {
      return deserialize<_i13.OperationResult>(data['data']);
    }
    if (dataClassName == 'PagedRequest') {
      return deserialize<_i14.PagedRequest>(data['data']);
    }
    if (dataClassName == 'SecurityEventRow') {
      return deserialize<_i15.SecurityEventRow>(data['data']);
    }
    if (dataClassName == 'FamilyDto') {
      return deserialize<_i16.FamilyDto>(data['data']);
    }
    if (dataClassName == 'FamilyInviteDto') {
      return deserialize<_i17.FamilyInviteDto>(data['data']);
    }
    if (dataClassName == 'FamilyInviteRow') {
      return deserialize<_i18.FamilyInviteRow>(data['data']);
    }
    if (dataClassName == 'FamilyMemberDto') {
      return deserialize<_i19.FamilyMemberDto>(data['data']);
    }
    if (dataClassName == 'FamilyMemberRow') {
      return deserialize<_i20.FamilyMemberRow>(data['data']);
    }
    if (dataClassName == 'FamilyRow') {
      return deserialize<_i21.FamilyRow>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i22.Greeting>(data['data']);
    }
    if (dataClassName == 'FamilyListDto') {
      return deserialize<_i23.FamilyListDto>(data['data']);
    }
    if (dataClassName == 'FamilyListRow') {
      return deserialize<_i24.FamilyListRow>(data['data']);
    }
    if (dataClassName == 'ListItemDto') {
      return deserialize<_i25.ListItemDto>(data['data']);
    }
    if (dataClassName == 'ListItemHistoryRow') {
      return deserialize<_i26.ListItemHistoryRow>(data['data']);
    }
    if (dataClassName == 'ListItemRow') {
      return deserialize<_i27.ListItemRow>(data['data']);
    }
    if (dataClassName == 'MediaAttachmentRow') {
      return deserialize<_i28.MediaAttachmentRow>(data['data']);
    }
    if (dataClassName == 'MediaObjectDto') {
      return deserialize<_i29.MediaObjectDto>(data['data']);
    }
    if (dataClassName == 'MediaObjectRow') {
      return deserialize<_i30.MediaObjectRow>(data['data']);
    }
    if (dataClassName == 'UploadSessionDto') {
      return deserialize<_i31.UploadSessionDto>(data['data']);
    }
    if (dataClassName == 'MoneyContributionDto') {
      return deserialize<_i32.MoneyContributionDto>(data['data']);
    }
    if (dataClassName == 'MoneyContributionRow') {
      return deserialize<_i33.MoneyContributionRow>(data['data']);
    }
    if (dataClassName == 'MoneyGoalDto') {
      return deserialize<_i34.MoneyGoalDto>(data['data']);
    }
    if (dataClassName == 'MoneyGoalRow') {
      return deserialize<_i35.MoneyGoalRow>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceDto') {
      return deserialize<_i36.NotificationPreferenceDto>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceRow') {
      return deserialize<_i37.NotificationPreferenceRow>(data['data']);
    }
    if (dataClassName == 'PushTokenRow') {
      return deserialize<_i38.PushTokenRow>(data['data']);
    }
    if (dataClassName == 'ReminderDto') {
      return deserialize<_i39.ReminderDto>(data['data']);
    }
    if (dataClassName == 'ReminderRow') {
      return deserialize<_i40.ReminderRow>(data['data']);
    }
    if (dataClassName == 'AccountDeletionRequestRow') {
      return deserialize<_i41.AccountDeletionRequestRow>(data['data']);
    }
    if (dataClassName == 'AccountDeletionStatusDto') {
      return deserialize<_i42.AccountDeletionStatusDto>(data['data']);
    }
    if (dataClassName == 'PrivacyExportJobDto') {
      return deserialize<_i43.PrivacyExportJobDto>(data['data']);
    }
    if (dataClassName == 'PrivacyExportJobRow') {
      return deserialize<_i44.PrivacyExportJobRow>(data['data']);
    }
    if (dataClassName == 'PrivacyStatusDto') {
      return deserialize<_i45.PrivacyStatusDto>(data['data']);
    }
    if (dataClassName == 'FamilyRealtimeEvent') {
      return deserialize<_i46.FamilyRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'SyncChangeDto') {
      return deserialize<_i47.SyncChangeDto>(data['data']);
    }
    if (dataClassName == 'SyncChangesResponse') {
      return deserialize<_i48.SyncChangesResponse>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i49.TaskDto>(data['data']);
    }
    if (dataClassName == 'TaskHistoryRow') {
      return deserialize<_i50.TaskHistoryRow>(data['data']);
    }
    if (dataClassName == 'TaskRow') {
      return deserialize<_i51.TaskRow>(data['data']);
    }
    if (dataClassName == 'AccountDeletionPayload') {
      return deserialize<_i52.AccountDeletionPayload>(data['data']);
    }
    if (dataClassName == 'MediaCleanupPayload') {
      return deserialize<_i53.MediaCleanupPayload>(data['data']);
    }
    if (dataClassName == 'NotificationsDuePayload') {
      return deserialize<_i54.NotificationsDuePayload>(data['data']);
    }
    if (dataClassName == 'PrivacyExportPayload') {
      return deserialize<_i55.PrivacyExportPayload>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i63.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i64.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i63.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i64.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
