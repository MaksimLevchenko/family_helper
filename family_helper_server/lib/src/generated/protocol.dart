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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'auth_profile/models/profile_dto.dart' as _i5;
import 'calendar/models/calendar_event_dto.dart' as _i6;
import 'calendar/models/calendar_instance_dto.dart' as _i7;
import 'core/models/api_error_dto.dart' as _i8;
import 'core/models/mutation_meta.dart' as _i9;
import 'core/models/operation_result.dart' as _i10;
import 'core/models/paged_request.dart' as _i11;
import 'family/models/family_dto.dart' as _i12;
import 'family/models/family_invite_dto.dart' as _i13;
import 'family/models/family_member_dto.dart' as _i14;
import 'greetings/greeting.dart' as _i15;
import 'lists/models/family_list_dto.dart' as _i16;
import 'lists/models/list_item_dto.dart' as _i17;
import 'media/models/media_object_dto.dart' as _i18;
import 'media/models/upload_session_dto.dart' as _i19;
import 'money_goals/models/money_contribution_dto.dart' as _i20;
import 'money_goals/models/money_goal_dto.dart' as _i21;
import 'notifications/models/notification_preference_dto.dart' as _i22;
import 'notifications/models/reminder_dto.dart' as _i23;
import 'privacy/models/account_deletion_status_dto.dart' as _i24;
import 'privacy/models/privacy_export_job_dto.dart' as _i25;
import 'realtime/models/family_realtime_event.dart' as _i26;
import 'sync/models/sync_change_dto.dart' as _i27;
import 'sync/models/sync_changes_response.dart' as _i28;
import 'tasks/models/task_dto.dart' as _i29;
import 'workers/models/account_deletion_payload.dart' as _i30;
import 'workers/models/media_cleanup_payload.dart' as _i31;
import 'workers/models/notifications_due_payload.dart' as _i32;
import 'workers/models/privacy_export_payload.dart' as _i33;
import 'package:family_helper_server/src/generated/calendar/models/calendar_instance_dto.dart'
    as _i34;
import 'package:family_helper_server/src/generated/family/models/family_member_dto.dart'
    as _i35;
import 'package:family_helper_server/src/generated/lists/models/list_item_dto.dart'
    as _i36;
import 'package:family_helper_server/src/generated/money_goals/models/money_goal_dto.dart'
    as _i37;
import 'package:family_helper_server/src/generated/tasks/models/task_dto.dart'
    as _i38;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.ProfileDto) {
      return _i5.ProfileDto.fromJson(data) as T;
    }
    if (t == _i6.CalendarEventDto) {
      return _i6.CalendarEventDto.fromJson(data) as T;
    }
    if (t == _i7.CalendarInstanceDto) {
      return _i7.CalendarInstanceDto.fromJson(data) as T;
    }
    if (t == _i8.ApiErrorDto) {
      return _i8.ApiErrorDto.fromJson(data) as T;
    }
    if (t == _i9.MutationMeta) {
      return _i9.MutationMeta.fromJson(data) as T;
    }
    if (t == _i10.OperationResult) {
      return _i10.OperationResult.fromJson(data) as T;
    }
    if (t == _i11.PagedRequest) {
      return _i11.PagedRequest.fromJson(data) as T;
    }
    if (t == _i12.FamilyDto) {
      return _i12.FamilyDto.fromJson(data) as T;
    }
    if (t == _i13.FamilyInviteDto) {
      return _i13.FamilyInviteDto.fromJson(data) as T;
    }
    if (t == _i14.FamilyMemberDto) {
      return _i14.FamilyMemberDto.fromJson(data) as T;
    }
    if (t == _i15.Greeting) {
      return _i15.Greeting.fromJson(data) as T;
    }
    if (t == _i16.FamilyListDto) {
      return _i16.FamilyListDto.fromJson(data) as T;
    }
    if (t == _i17.ListItemDto) {
      return _i17.ListItemDto.fromJson(data) as T;
    }
    if (t == _i18.MediaObjectDto) {
      return _i18.MediaObjectDto.fromJson(data) as T;
    }
    if (t == _i19.UploadSessionDto) {
      return _i19.UploadSessionDto.fromJson(data) as T;
    }
    if (t == _i20.MoneyContributionDto) {
      return _i20.MoneyContributionDto.fromJson(data) as T;
    }
    if (t == _i21.MoneyGoalDto) {
      return _i21.MoneyGoalDto.fromJson(data) as T;
    }
    if (t == _i22.NotificationPreferenceDto) {
      return _i22.NotificationPreferenceDto.fromJson(data) as T;
    }
    if (t == _i23.ReminderDto) {
      return _i23.ReminderDto.fromJson(data) as T;
    }
    if (t == _i24.AccountDeletionStatusDto) {
      return _i24.AccountDeletionStatusDto.fromJson(data) as T;
    }
    if (t == _i25.PrivacyExportJobDto) {
      return _i25.PrivacyExportJobDto.fromJson(data) as T;
    }
    if (t == _i26.FamilyRealtimeEvent) {
      return _i26.FamilyRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i27.SyncChangeDto) {
      return _i27.SyncChangeDto.fromJson(data) as T;
    }
    if (t == _i28.SyncChangesResponse) {
      return _i28.SyncChangesResponse.fromJson(data) as T;
    }
    if (t == _i29.TaskDto) {
      return _i29.TaskDto.fromJson(data) as T;
    }
    if (t == _i30.AccountDeletionPayload) {
      return _i30.AccountDeletionPayload.fromJson(data) as T;
    }
    if (t == _i31.MediaCleanupPayload) {
      return _i31.MediaCleanupPayload.fromJson(data) as T;
    }
    if (t == _i32.NotificationsDuePayload) {
      return _i32.NotificationsDuePayload.fromJson(data) as T;
    }
    if (t == _i33.PrivacyExportPayload) {
      return _i33.PrivacyExportPayload.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ProfileDto?>()) {
      return (data != null ? _i5.ProfileDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CalendarEventDto?>()) {
      return (data != null ? _i6.CalendarEventDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CalendarInstanceDto?>()) {
      return (data != null ? _i7.CalendarInstanceDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ApiErrorDto?>()) {
      return (data != null ? _i8.ApiErrorDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.MutationMeta?>()) {
      return (data != null ? _i9.MutationMeta.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.OperationResult?>()) {
      return (data != null ? _i10.OperationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.PagedRequest?>()) {
      return (data != null ? _i11.PagedRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.FamilyDto?>()) {
      return (data != null ? _i12.FamilyDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.FamilyInviteDto?>()) {
      return (data != null ? _i13.FamilyInviteDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.FamilyMemberDto?>()) {
      return (data != null ? _i14.FamilyMemberDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Greeting?>()) {
      return (data != null ? _i15.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.FamilyListDto?>()) {
      return (data != null ? _i16.FamilyListDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ListItemDto?>()) {
      return (data != null ? _i17.ListItemDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.MediaObjectDto?>()) {
      return (data != null ? _i18.MediaObjectDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.UploadSessionDto?>()) {
      return (data != null ? _i19.UploadSessionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.MoneyContributionDto?>()) {
      return (data != null ? _i20.MoneyContributionDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.MoneyGoalDto?>()) {
      return (data != null ? _i21.MoneyGoalDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.NotificationPreferenceDto?>()) {
      return (data != null
              ? _i22.NotificationPreferenceDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i23.ReminderDto?>()) {
      return (data != null ? _i23.ReminderDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.AccountDeletionStatusDto?>()) {
      return (data != null
              ? _i24.AccountDeletionStatusDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.PrivacyExportJobDto?>()) {
      return (data != null ? _i25.PrivacyExportJobDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.FamilyRealtimeEvent?>()) {
      return (data != null ? _i26.FamilyRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.SyncChangeDto?>()) {
      return (data != null ? _i27.SyncChangeDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.SyncChangesResponse?>()) {
      return (data != null ? _i28.SyncChangesResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.TaskDto?>()) {
      return (data != null ? _i29.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.AccountDeletionPayload?>()) {
      return (data != null ? _i30.AccountDeletionPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.MediaCleanupPayload?>()) {
      return (data != null ? _i31.MediaCleanupPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.NotificationsDuePayload?>()) {
      return (data != null ? _i32.NotificationsDuePayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.PrivacyExportPayload?>()) {
      return (data != null ? _i33.PrivacyExportPayload.fromJson(data) : null)
          as T;
    }
    if (t == List<_i27.SyncChangeDto>) {
      return (data as List)
              .map((e) => deserialize<_i27.SyncChangeDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.CalendarInstanceDto>) {
      return (data as List)
              .map((e) => deserialize<_i34.CalendarInstanceDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.FamilyMemberDto>) {
      return (data as List)
              .map((e) => deserialize<_i35.FamilyMemberDto>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i36.ListItemDto>) {
      return (data as List)
              .map((e) => deserialize<_i36.ListItemDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.MoneyGoalDto>) {
      return (data as List)
              .map((e) => deserialize<_i37.MoneyGoalDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.TaskDto>) {
      return (data as List).map((e) => deserialize<_i38.TaskDto>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.ProfileDto => 'ProfileDto',
      _i6.CalendarEventDto => 'CalendarEventDto',
      _i7.CalendarInstanceDto => 'CalendarInstanceDto',
      _i8.ApiErrorDto => 'ApiErrorDto',
      _i9.MutationMeta => 'MutationMeta',
      _i10.OperationResult => 'OperationResult',
      _i11.PagedRequest => 'PagedRequest',
      _i12.FamilyDto => 'FamilyDto',
      _i13.FamilyInviteDto => 'FamilyInviteDto',
      _i14.FamilyMemberDto => 'FamilyMemberDto',
      _i15.Greeting => 'Greeting',
      _i16.FamilyListDto => 'FamilyListDto',
      _i17.ListItemDto => 'ListItemDto',
      _i18.MediaObjectDto => 'MediaObjectDto',
      _i19.UploadSessionDto => 'UploadSessionDto',
      _i20.MoneyContributionDto => 'MoneyContributionDto',
      _i21.MoneyGoalDto => 'MoneyGoalDto',
      _i22.NotificationPreferenceDto => 'NotificationPreferenceDto',
      _i23.ReminderDto => 'ReminderDto',
      _i24.AccountDeletionStatusDto => 'AccountDeletionStatusDto',
      _i25.PrivacyExportJobDto => 'PrivacyExportJobDto',
      _i26.FamilyRealtimeEvent => 'FamilyRealtimeEvent',
      _i27.SyncChangeDto => 'SyncChangeDto',
      _i28.SyncChangesResponse => 'SyncChangesResponse',
      _i29.TaskDto => 'TaskDto',
      _i30.AccountDeletionPayload => 'AccountDeletionPayload',
      _i31.MediaCleanupPayload => 'MediaCleanupPayload',
      _i32.NotificationsDuePayload => 'NotificationsDuePayload',
      _i33.PrivacyExportPayload => 'PrivacyExportPayload',
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
      case _i5.ProfileDto():
        return 'ProfileDto';
      case _i6.CalendarEventDto():
        return 'CalendarEventDto';
      case _i7.CalendarInstanceDto():
        return 'CalendarInstanceDto';
      case _i8.ApiErrorDto():
        return 'ApiErrorDto';
      case _i9.MutationMeta():
        return 'MutationMeta';
      case _i10.OperationResult():
        return 'OperationResult';
      case _i11.PagedRequest():
        return 'PagedRequest';
      case _i12.FamilyDto():
        return 'FamilyDto';
      case _i13.FamilyInviteDto():
        return 'FamilyInviteDto';
      case _i14.FamilyMemberDto():
        return 'FamilyMemberDto';
      case _i15.Greeting():
        return 'Greeting';
      case _i16.FamilyListDto():
        return 'FamilyListDto';
      case _i17.ListItemDto():
        return 'ListItemDto';
      case _i18.MediaObjectDto():
        return 'MediaObjectDto';
      case _i19.UploadSessionDto():
        return 'UploadSessionDto';
      case _i20.MoneyContributionDto():
        return 'MoneyContributionDto';
      case _i21.MoneyGoalDto():
        return 'MoneyGoalDto';
      case _i22.NotificationPreferenceDto():
        return 'NotificationPreferenceDto';
      case _i23.ReminderDto():
        return 'ReminderDto';
      case _i24.AccountDeletionStatusDto():
        return 'AccountDeletionStatusDto';
      case _i25.PrivacyExportJobDto():
        return 'PrivacyExportJobDto';
      case _i26.FamilyRealtimeEvent():
        return 'FamilyRealtimeEvent';
      case _i27.SyncChangeDto():
        return 'SyncChangeDto';
      case _i28.SyncChangesResponse():
        return 'SyncChangesResponse';
      case _i29.TaskDto():
        return 'TaskDto';
      case _i30.AccountDeletionPayload():
        return 'AccountDeletionPayload';
      case _i31.MediaCleanupPayload():
        return 'MediaCleanupPayload';
      case _i32.NotificationsDuePayload():
        return 'NotificationsDuePayload';
      case _i33.PrivacyExportPayload():
        return 'PrivacyExportPayload';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.ProfileDto>(data['data']);
    }
    if (dataClassName == 'CalendarEventDto') {
      return deserialize<_i6.CalendarEventDto>(data['data']);
    }
    if (dataClassName == 'CalendarInstanceDto') {
      return deserialize<_i7.CalendarInstanceDto>(data['data']);
    }
    if (dataClassName == 'ApiErrorDto') {
      return deserialize<_i8.ApiErrorDto>(data['data']);
    }
    if (dataClassName == 'MutationMeta') {
      return deserialize<_i9.MutationMeta>(data['data']);
    }
    if (dataClassName == 'OperationResult') {
      return deserialize<_i10.OperationResult>(data['data']);
    }
    if (dataClassName == 'PagedRequest') {
      return deserialize<_i11.PagedRequest>(data['data']);
    }
    if (dataClassName == 'FamilyDto') {
      return deserialize<_i12.FamilyDto>(data['data']);
    }
    if (dataClassName == 'FamilyInviteDto') {
      return deserialize<_i13.FamilyInviteDto>(data['data']);
    }
    if (dataClassName == 'FamilyMemberDto') {
      return deserialize<_i14.FamilyMemberDto>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i15.Greeting>(data['data']);
    }
    if (dataClassName == 'FamilyListDto') {
      return deserialize<_i16.FamilyListDto>(data['data']);
    }
    if (dataClassName == 'ListItemDto') {
      return deserialize<_i17.ListItemDto>(data['data']);
    }
    if (dataClassName == 'MediaObjectDto') {
      return deserialize<_i18.MediaObjectDto>(data['data']);
    }
    if (dataClassName == 'UploadSessionDto') {
      return deserialize<_i19.UploadSessionDto>(data['data']);
    }
    if (dataClassName == 'MoneyContributionDto') {
      return deserialize<_i20.MoneyContributionDto>(data['data']);
    }
    if (dataClassName == 'MoneyGoalDto') {
      return deserialize<_i21.MoneyGoalDto>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceDto') {
      return deserialize<_i22.NotificationPreferenceDto>(data['data']);
    }
    if (dataClassName == 'ReminderDto') {
      return deserialize<_i23.ReminderDto>(data['data']);
    }
    if (dataClassName == 'AccountDeletionStatusDto') {
      return deserialize<_i24.AccountDeletionStatusDto>(data['data']);
    }
    if (dataClassName == 'PrivacyExportJobDto') {
      return deserialize<_i25.PrivacyExportJobDto>(data['data']);
    }
    if (dataClassName == 'FamilyRealtimeEvent') {
      return deserialize<_i26.FamilyRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'SyncChangeDto') {
      return deserialize<_i27.SyncChangeDto>(data['data']);
    }
    if (dataClassName == 'SyncChangesResponse') {
      return deserialize<_i28.SyncChangesResponse>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i29.TaskDto>(data['data']);
    }
    if (dataClassName == 'AccountDeletionPayload') {
      return deserialize<_i30.AccountDeletionPayload>(data['data']);
    }
    if (dataClassName == 'MediaCleanupPayload') {
      return deserialize<_i31.MediaCleanupPayload>(data['data']);
    }
    if (dataClassName == 'NotificationsDuePayload') {
      return deserialize<_i32.NotificationsDuePayload>(data['data']);
    }
    if (dataClassName == 'PrivacyExportPayload') {
      return deserialize<_i33.PrivacyExportPayload>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'family_helper';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
