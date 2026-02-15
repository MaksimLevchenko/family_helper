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
import 'calendar/models/calendar_instance_dto.dart' as _i4;
import 'core/models/api_error_dto.dart' as _i5;
import 'core/models/mutation_meta.dart' as _i6;
import 'core/models/operation_result.dart' as _i7;
import 'core/models/paged_request.dart' as _i8;
import 'family/models/family_dto.dart' as _i9;
import 'family/models/family_invite_dto.dart' as _i10;
import 'family/models/family_member_dto.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'lists/models/family_list_dto.dart' as _i13;
import 'lists/models/list_item_dto.dart' as _i14;
import 'media/models/media_object_dto.dart' as _i15;
import 'media/models/upload_session_dto.dart' as _i16;
import 'money_goals/models/money_contribution_dto.dart' as _i17;
import 'money_goals/models/money_goal_dto.dart' as _i18;
import 'notifications/models/notification_preference_dto.dart' as _i19;
import 'notifications/models/reminder_dto.dart' as _i20;
import 'privacy/models/account_deletion_status_dto.dart' as _i21;
import 'privacy/models/privacy_export_job_dto.dart' as _i22;
import 'realtime/models/family_realtime_event.dart' as _i23;
import 'sync/models/sync_change_dto.dart' as _i24;
import 'sync/models/sync_changes_response.dart' as _i25;
import 'tasks/models/task_dto.dart' as _i26;
import 'workers/models/account_deletion_payload.dart' as _i27;
import 'workers/models/media_cleanup_payload.dart' as _i28;
import 'workers/models/notifications_due_payload.dart' as _i29;
import 'workers/models/privacy_export_payload.dart' as _i30;
import 'package:family_helper_client/src/protocol/calendar/models/calendar_instance_dto.dart'
    as _i31;
import 'package:family_helper_client/src/protocol/family/models/family_member_dto.dart'
    as _i32;
import 'package:family_helper_client/src/protocol/lists/models/list_item_dto.dart'
    as _i33;
import 'package:family_helper_client/src/protocol/money_goals/models/money_goal_dto.dart'
    as _i34;
import 'package:family_helper_client/src/protocol/tasks/models/task_dto.dart'
    as _i35;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i36;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i37;
export 'auth_profile/models/profile_dto.dart';
export 'calendar/models/calendar_event_dto.dart';
export 'calendar/models/calendar_instance_dto.dart';
export 'core/models/api_error_dto.dart';
export 'core/models/mutation_meta.dart';
export 'core/models/operation_result.dart';
export 'core/models/paged_request.dart';
export 'family/models/family_dto.dart';
export 'family/models/family_invite_dto.dart';
export 'family/models/family_member_dto.dart';
export 'greetings/greeting.dart';
export 'lists/models/family_list_dto.dart';
export 'lists/models/list_item_dto.dart';
export 'media/models/media_object_dto.dart';
export 'media/models/upload_session_dto.dart';
export 'money_goals/models/money_contribution_dto.dart';
export 'money_goals/models/money_goal_dto.dart';
export 'notifications/models/notification_preference_dto.dart';
export 'notifications/models/reminder_dto.dart';
export 'privacy/models/account_deletion_status_dto.dart';
export 'privacy/models/privacy_export_job_dto.dart';
export 'realtime/models/family_realtime_event.dart';
export 'sync/models/sync_change_dto.dart';
export 'sync/models/sync_changes_response.dart';
export 'tasks/models/task_dto.dart';
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
    if (t == _i4.CalendarInstanceDto) {
      return _i4.CalendarInstanceDto.fromJson(data) as T;
    }
    if (t == _i5.ApiErrorDto) {
      return _i5.ApiErrorDto.fromJson(data) as T;
    }
    if (t == _i6.MutationMeta) {
      return _i6.MutationMeta.fromJson(data) as T;
    }
    if (t == _i7.OperationResult) {
      return _i7.OperationResult.fromJson(data) as T;
    }
    if (t == _i8.PagedRequest) {
      return _i8.PagedRequest.fromJson(data) as T;
    }
    if (t == _i9.FamilyDto) {
      return _i9.FamilyDto.fromJson(data) as T;
    }
    if (t == _i10.FamilyInviteDto) {
      return _i10.FamilyInviteDto.fromJson(data) as T;
    }
    if (t == _i11.FamilyMemberDto) {
      return _i11.FamilyMemberDto.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.FamilyListDto) {
      return _i13.FamilyListDto.fromJson(data) as T;
    }
    if (t == _i14.ListItemDto) {
      return _i14.ListItemDto.fromJson(data) as T;
    }
    if (t == _i15.MediaObjectDto) {
      return _i15.MediaObjectDto.fromJson(data) as T;
    }
    if (t == _i16.UploadSessionDto) {
      return _i16.UploadSessionDto.fromJson(data) as T;
    }
    if (t == _i17.MoneyContributionDto) {
      return _i17.MoneyContributionDto.fromJson(data) as T;
    }
    if (t == _i18.MoneyGoalDto) {
      return _i18.MoneyGoalDto.fromJson(data) as T;
    }
    if (t == _i19.NotificationPreferenceDto) {
      return _i19.NotificationPreferenceDto.fromJson(data) as T;
    }
    if (t == _i20.ReminderDto) {
      return _i20.ReminderDto.fromJson(data) as T;
    }
    if (t == _i21.AccountDeletionStatusDto) {
      return _i21.AccountDeletionStatusDto.fromJson(data) as T;
    }
    if (t == _i22.PrivacyExportJobDto) {
      return _i22.PrivacyExportJobDto.fromJson(data) as T;
    }
    if (t == _i23.FamilyRealtimeEvent) {
      return _i23.FamilyRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i24.SyncChangeDto) {
      return _i24.SyncChangeDto.fromJson(data) as T;
    }
    if (t == _i25.SyncChangesResponse) {
      return _i25.SyncChangesResponse.fromJson(data) as T;
    }
    if (t == _i26.TaskDto) {
      return _i26.TaskDto.fromJson(data) as T;
    }
    if (t == _i27.AccountDeletionPayload) {
      return _i27.AccountDeletionPayload.fromJson(data) as T;
    }
    if (t == _i28.MediaCleanupPayload) {
      return _i28.MediaCleanupPayload.fromJson(data) as T;
    }
    if (t == _i29.NotificationsDuePayload) {
      return _i29.NotificationsDuePayload.fromJson(data) as T;
    }
    if (t == _i30.PrivacyExportPayload) {
      return _i30.PrivacyExportPayload.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ProfileDto?>()) {
      return (data != null ? _i2.ProfileDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CalendarEventDto?>()) {
      return (data != null ? _i3.CalendarEventDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CalendarInstanceDto?>()) {
      return (data != null ? _i4.CalendarInstanceDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ApiErrorDto?>()) {
      return (data != null ? _i5.ApiErrorDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.MutationMeta?>()) {
      return (data != null ? _i6.MutationMeta.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.OperationResult?>()) {
      return (data != null ? _i7.OperationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PagedRequest?>()) {
      return (data != null ? _i8.PagedRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.FamilyDto?>()) {
      return (data != null ? _i9.FamilyDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.FamilyInviteDto?>()) {
      return (data != null ? _i10.FamilyInviteDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.FamilyMemberDto?>()) {
      return (data != null ? _i11.FamilyMemberDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.FamilyListDto?>()) {
      return (data != null ? _i13.FamilyListDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ListItemDto?>()) {
      return (data != null ? _i14.ListItemDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.MediaObjectDto?>()) {
      return (data != null ? _i15.MediaObjectDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UploadSessionDto?>()) {
      return (data != null ? _i16.UploadSessionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.MoneyContributionDto?>()) {
      return (data != null ? _i17.MoneyContributionDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.MoneyGoalDto?>()) {
      return (data != null ? _i18.MoneyGoalDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.NotificationPreferenceDto?>()) {
      return (data != null
              ? _i19.NotificationPreferenceDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i20.ReminderDto?>()) {
      return (data != null ? _i20.ReminderDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.AccountDeletionStatusDto?>()) {
      return (data != null
              ? _i21.AccountDeletionStatusDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i22.PrivacyExportJobDto?>()) {
      return (data != null ? _i22.PrivacyExportJobDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.FamilyRealtimeEvent?>()) {
      return (data != null ? _i23.FamilyRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.SyncChangeDto?>()) {
      return (data != null ? _i24.SyncChangeDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.SyncChangesResponse?>()) {
      return (data != null ? _i25.SyncChangesResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.TaskDto?>()) {
      return (data != null ? _i26.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.AccountDeletionPayload?>()) {
      return (data != null ? _i27.AccountDeletionPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.MediaCleanupPayload?>()) {
      return (data != null ? _i28.MediaCleanupPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.NotificationsDuePayload?>()) {
      return (data != null ? _i29.NotificationsDuePayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.PrivacyExportPayload?>()) {
      return (data != null ? _i30.PrivacyExportPayload.fromJson(data) : null)
          as T;
    }
    if (t == List<_i24.SyncChangeDto>) {
      return (data as List)
              .map((e) => deserialize<_i24.SyncChangeDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.CalendarInstanceDto>) {
      return (data as List)
              .map((e) => deserialize<_i31.CalendarInstanceDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.FamilyMemberDto>) {
      return (data as List)
              .map((e) => deserialize<_i32.FamilyMemberDto>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i33.ListItemDto>) {
      return (data as List)
              .map((e) => deserialize<_i33.ListItemDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.MoneyGoalDto>) {
      return (data as List)
              .map((e) => deserialize<_i34.MoneyGoalDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.TaskDto>) {
      return (data as List).map((e) => deserialize<_i35.TaskDto>(e)).toList()
          as T;
    }
    try {
      return _i36.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i37.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ProfileDto => 'ProfileDto',
      _i3.CalendarEventDto => 'CalendarEventDto',
      _i4.CalendarInstanceDto => 'CalendarInstanceDto',
      _i5.ApiErrorDto => 'ApiErrorDto',
      _i6.MutationMeta => 'MutationMeta',
      _i7.OperationResult => 'OperationResult',
      _i8.PagedRequest => 'PagedRequest',
      _i9.FamilyDto => 'FamilyDto',
      _i10.FamilyInviteDto => 'FamilyInviteDto',
      _i11.FamilyMemberDto => 'FamilyMemberDto',
      _i12.Greeting => 'Greeting',
      _i13.FamilyListDto => 'FamilyListDto',
      _i14.ListItemDto => 'ListItemDto',
      _i15.MediaObjectDto => 'MediaObjectDto',
      _i16.UploadSessionDto => 'UploadSessionDto',
      _i17.MoneyContributionDto => 'MoneyContributionDto',
      _i18.MoneyGoalDto => 'MoneyGoalDto',
      _i19.NotificationPreferenceDto => 'NotificationPreferenceDto',
      _i20.ReminderDto => 'ReminderDto',
      _i21.AccountDeletionStatusDto => 'AccountDeletionStatusDto',
      _i22.PrivacyExportJobDto => 'PrivacyExportJobDto',
      _i23.FamilyRealtimeEvent => 'FamilyRealtimeEvent',
      _i24.SyncChangeDto => 'SyncChangeDto',
      _i25.SyncChangesResponse => 'SyncChangesResponse',
      _i26.TaskDto => 'TaskDto',
      _i27.AccountDeletionPayload => 'AccountDeletionPayload',
      _i28.MediaCleanupPayload => 'MediaCleanupPayload',
      _i29.NotificationsDuePayload => 'NotificationsDuePayload',
      _i30.PrivacyExportPayload => 'PrivacyExportPayload',
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
      case _i4.CalendarInstanceDto():
        return 'CalendarInstanceDto';
      case _i5.ApiErrorDto():
        return 'ApiErrorDto';
      case _i6.MutationMeta():
        return 'MutationMeta';
      case _i7.OperationResult():
        return 'OperationResult';
      case _i8.PagedRequest():
        return 'PagedRequest';
      case _i9.FamilyDto():
        return 'FamilyDto';
      case _i10.FamilyInviteDto():
        return 'FamilyInviteDto';
      case _i11.FamilyMemberDto():
        return 'FamilyMemberDto';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.FamilyListDto():
        return 'FamilyListDto';
      case _i14.ListItemDto():
        return 'ListItemDto';
      case _i15.MediaObjectDto():
        return 'MediaObjectDto';
      case _i16.UploadSessionDto():
        return 'UploadSessionDto';
      case _i17.MoneyContributionDto():
        return 'MoneyContributionDto';
      case _i18.MoneyGoalDto():
        return 'MoneyGoalDto';
      case _i19.NotificationPreferenceDto():
        return 'NotificationPreferenceDto';
      case _i20.ReminderDto():
        return 'ReminderDto';
      case _i21.AccountDeletionStatusDto():
        return 'AccountDeletionStatusDto';
      case _i22.PrivacyExportJobDto():
        return 'PrivacyExportJobDto';
      case _i23.FamilyRealtimeEvent():
        return 'FamilyRealtimeEvent';
      case _i24.SyncChangeDto():
        return 'SyncChangeDto';
      case _i25.SyncChangesResponse():
        return 'SyncChangesResponse';
      case _i26.TaskDto():
        return 'TaskDto';
      case _i27.AccountDeletionPayload():
        return 'AccountDeletionPayload';
      case _i28.MediaCleanupPayload():
        return 'MediaCleanupPayload';
      case _i29.NotificationsDuePayload():
        return 'NotificationsDuePayload';
      case _i30.PrivacyExportPayload():
        return 'PrivacyExportPayload';
    }
    className = _i36.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i37.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CalendarInstanceDto') {
      return deserialize<_i4.CalendarInstanceDto>(data['data']);
    }
    if (dataClassName == 'ApiErrorDto') {
      return deserialize<_i5.ApiErrorDto>(data['data']);
    }
    if (dataClassName == 'MutationMeta') {
      return deserialize<_i6.MutationMeta>(data['data']);
    }
    if (dataClassName == 'OperationResult') {
      return deserialize<_i7.OperationResult>(data['data']);
    }
    if (dataClassName == 'PagedRequest') {
      return deserialize<_i8.PagedRequest>(data['data']);
    }
    if (dataClassName == 'FamilyDto') {
      return deserialize<_i9.FamilyDto>(data['data']);
    }
    if (dataClassName == 'FamilyInviteDto') {
      return deserialize<_i10.FamilyInviteDto>(data['data']);
    }
    if (dataClassName == 'FamilyMemberDto') {
      return deserialize<_i11.FamilyMemberDto>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'FamilyListDto') {
      return deserialize<_i13.FamilyListDto>(data['data']);
    }
    if (dataClassName == 'ListItemDto') {
      return deserialize<_i14.ListItemDto>(data['data']);
    }
    if (dataClassName == 'MediaObjectDto') {
      return deserialize<_i15.MediaObjectDto>(data['data']);
    }
    if (dataClassName == 'UploadSessionDto') {
      return deserialize<_i16.UploadSessionDto>(data['data']);
    }
    if (dataClassName == 'MoneyContributionDto') {
      return deserialize<_i17.MoneyContributionDto>(data['data']);
    }
    if (dataClassName == 'MoneyGoalDto') {
      return deserialize<_i18.MoneyGoalDto>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceDto') {
      return deserialize<_i19.NotificationPreferenceDto>(data['data']);
    }
    if (dataClassName == 'ReminderDto') {
      return deserialize<_i20.ReminderDto>(data['data']);
    }
    if (dataClassName == 'AccountDeletionStatusDto') {
      return deserialize<_i21.AccountDeletionStatusDto>(data['data']);
    }
    if (dataClassName == 'PrivacyExportJobDto') {
      return deserialize<_i22.PrivacyExportJobDto>(data['data']);
    }
    if (dataClassName == 'FamilyRealtimeEvent') {
      return deserialize<_i23.FamilyRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'SyncChangeDto') {
      return deserialize<_i24.SyncChangeDto>(data['data']);
    }
    if (dataClassName == 'SyncChangesResponse') {
      return deserialize<_i25.SyncChangesResponse>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i26.TaskDto>(data['data']);
    }
    if (dataClassName == 'AccountDeletionPayload') {
      return deserialize<_i27.AccountDeletionPayload>(data['data']);
    }
    if (dataClassName == 'MediaCleanupPayload') {
      return deserialize<_i28.MediaCleanupPayload>(data['data']);
    }
    if (dataClassName == 'NotificationsDuePayload') {
      return deserialize<_i29.NotificationsDuePayload>(data['data']);
    }
    if (dataClassName == 'PrivacyExportPayload') {
      return deserialize<_i30.PrivacyExportPayload>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i36.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i37.Protocol().deserializeByClassName(data);
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
      return _i36.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i37.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
