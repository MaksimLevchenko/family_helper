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
import 'calendar/models/calendar_event_override_row.dart' as _i7;
import 'calendar/models/calendar_event_row.dart' as _i8;
import 'calendar/models/calendar_instance_dto.dart' as _i9;
import 'core/models/api_error_dto.dart' as _i10;
import 'core/models/app_profile_row.dart' as _i11;
import 'core/models/audit_log_row.dart' as _i12;
import 'core/models/change_feed_row.dart' as _i13;
import 'core/models/idempotency_key_row.dart' as _i14;
import 'core/models/mutation_meta.dart' as _i15;
import 'core/models/operation_result.dart' as _i16;
import 'core/models/paged_request.dart' as _i17;
import 'core/models/security_event_row.dart' as _i18;
import 'family/models/family_dto.dart' as _i19;
import 'family/models/family_invite_dto.dart' as _i20;
import 'family/models/family_invite_row.dart' as _i21;
import 'family/models/family_member_dto.dart' as _i22;
import 'family/models/family_member_row.dart' as _i23;
import 'family/models/family_row.dart' as _i24;
import 'greetings/greeting.dart' as _i25;
import 'lists/models/family_list_dto.dart' as _i26;
import 'lists/models/family_list_row.dart' as _i27;
import 'lists/models/list_item_dto.dart' as _i28;
import 'lists/models/list_item_history_row.dart' as _i29;
import 'lists/models/list_item_row.dart' as _i30;
import 'media/models/media_attachment_row.dart' as _i31;
import 'media/models/media_object_dto.dart' as _i32;
import 'media/models/media_object_row.dart' as _i33;
import 'media/models/upload_session_dto.dart' as _i34;
import 'money_goals/models/money_contribution_dto.dart' as _i35;
import 'money_goals/models/money_contribution_row.dart' as _i36;
import 'money_goals/models/money_goal_dto.dart' as _i37;
import 'money_goals/models/money_goal_row.dart' as _i38;
import 'notifications/models/notification_preference_dto.dart' as _i39;
import 'notifications/models/notification_preference_row.dart' as _i40;
import 'notifications/models/push_token_row.dart' as _i41;
import 'notifications/models/reminder_dto.dart' as _i42;
import 'notifications/models/reminder_row.dart' as _i43;
import 'privacy/models/account_deletion_request_row.dart' as _i44;
import 'privacy/models/account_deletion_status_dto.dart' as _i45;
import 'privacy/models/privacy_export_job_dto.dart' as _i46;
import 'privacy/models/privacy_export_job_row.dart' as _i47;
import 'realtime/models/family_realtime_event.dart' as _i48;
import 'sync/models/sync_change_dto.dart' as _i49;
import 'sync/models/sync_changes_response.dart' as _i50;
import 'tasks/models/task_dto.dart' as _i51;
import 'tasks/models/task_history_row.dart' as _i52;
import 'tasks/models/task_row.dart' as _i53;
import 'workers/models/account_deletion_payload.dart' as _i54;
import 'workers/models/media_cleanup_payload.dart' as _i55;
import 'workers/models/notifications_due_payload.dart' as _i56;
import 'workers/models/privacy_export_payload.dart' as _i57;
import 'package:family_helper_server/src/generated/calendar/models/calendar_instance_dto.dart'
    as _i58;
import 'package:family_helper_server/src/generated/family/models/family_member_dto.dart'
    as _i59;
import 'package:family_helper_server/src/generated/lists/models/list_item_dto.dart'
    as _i60;
import 'package:family_helper_server/src/generated/money_goals/models/money_goal_dto.dart'
    as _i61;
import 'package:family_helper_server/src/generated/tasks/models/task_dto.dart'
    as _i62;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'account_deletion_request',
      dartName: 'AccountDeletionRequestRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'account_deletion_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scheduledHardDeleteAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'cancelledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_deletion_request_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'account_deletion_request_profile_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'profileId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'app_profile',
      dartName: 'AppProfileRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'app_profile_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'displayName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'timezone',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'avatarMediaId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'analyticsOptIn',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'app_profile_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'app_profile_auth_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'audit_log',
      dartName: 'AuditLogRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'audit_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'actorProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'action',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'payloadJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'audit_log_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'calendar_event',
      dartName: 'CalendarEventRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'calendar_event_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'timezone',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'rrule',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'colorKey',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'calendar_event_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'calendar_event_override',
      dartName: 'CalendarEventOverrideRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'calendar_event_override_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'eventId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'occurrenceStart',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'overrideTitle',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'overrideStartsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'overrideEndsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'cancelled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'calendar_event_override_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'change_feed',
      dartName: 'ChangeFeedRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'change_feed_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'feature',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'entityType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'entityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'operation',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'changedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'tombstone',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'payloadJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'change_feed_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'family',
      dartName: 'FamilyRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'family_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'ownerProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'memberLimit',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'family_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'family_invite',
      dartName: 'FamilyInviteRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'family_invite_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'inviteType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'inviteCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'family_invite_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'family_list',
      dartName: 'FamilyListRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'family_list_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'listType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'family_list_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'family_member',
      dartName: 'FamilyMemberRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'family_member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'family_member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'idempotency_key',
      dartName: 'IdempotencyKeyRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'idempotency_key_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'actorAuthUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'action',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'clientOperationId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'resourceType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'resourceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'idempotency_key_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'idempotency_key_actor_action_client_operation_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'actorAuthUserId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'action',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'clientOperationId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'list_item',
      dartName: 'ListItemRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'list_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'listId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'qty',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'unit',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'priceCents',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'positionIndex',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'isBought',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'boughtByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'boughtAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'list_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'list_item_history',
      dartName: 'ListItemHistoryRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'list_item_history_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'itemId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'actorProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'eventType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'list_item_history_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'media_attachment',
      dartName: 'MediaAttachmentRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'media_attachment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'mediaId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'entityType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'entityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'media_attachment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'media_object',
      dartName: 'MediaObjectRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'media_object_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'uploadedByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'objectKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'bucket',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'mimeType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sizeBytes',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'thumbnailKey',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'clientOperationId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'uploadExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'media_object_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'money_contribution',
      dartName: 'MoneyContributionRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'money_contribution_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'goalId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'amountCents',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'clientOperationId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'revokedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'money_contribution_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'money_contribution_goal_client_operation_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'goalId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'clientOperationId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'money_goal',
      dartName: 'MoneyGoalRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'money_goal_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'targetAmountCents',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currentAmountCents',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deadlineAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'reachedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'money_goal_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'notification_preference',
      dartName: 'NotificationPreferenceRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'notification_preference_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'notificationType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'enabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'quietHoursStart',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'quietHoursEnd',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notification_preference_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_preference_profile_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'profileId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'notificationType',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'privacy_export_job',
      dartName: 'PrivacyExportJobRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'privacy_export_job_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'objectKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'signedUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'completedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'privacy_export_job_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'push_token',
      dartName: 'PushTokenRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'push_token_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'platform',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'push_token_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'push_token_profile_token_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'profileId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'reminder',
      dartName: 'ReminderRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'reminder_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'entityType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'entityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'profileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'remindAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'payloadJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'clientOperationId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'firedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'reminder_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'security_event',
      dartName: 'SecurityEventRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'security_event_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'eventType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'success',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'payloadJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'security_event_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'task',
      dartName: 'TaskRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'task_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'familyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isPersonal',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'dueAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'recurrenceMode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'recurrenceRrule',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'assigneeProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdByProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'completedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'sourceTaskId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'task_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'task_history',
      dartName: 'TaskHistoryRow',
      schema: 'public',
      module: 'family_helper',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'task_history_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'taskId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'actorProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'eventType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'details',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'task_history_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
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
    if (t == _i7.CalendarEventOverrideRow) {
      return _i7.CalendarEventOverrideRow.fromJson(data) as T;
    }
    if (t == _i8.CalendarEventRow) {
      return _i8.CalendarEventRow.fromJson(data) as T;
    }
    if (t == _i9.CalendarInstanceDto) {
      return _i9.CalendarInstanceDto.fromJson(data) as T;
    }
    if (t == _i10.ApiErrorDto) {
      return _i10.ApiErrorDto.fromJson(data) as T;
    }
    if (t == _i11.AppProfileRow) {
      return _i11.AppProfileRow.fromJson(data) as T;
    }
    if (t == _i12.AuditLogRow) {
      return _i12.AuditLogRow.fromJson(data) as T;
    }
    if (t == _i13.ChangeFeedRow) {
      return _i13.ChangeFeedRow.fromJson(data) as T;
    }
    if (t == _i14.IdempotencyKeyRow) {
      return _i14.IdempotencyKeyRow.fromJson(data) as T;
    }
    if (t == _i15.MutationMeta) {
      return _i15.MutationMeta.fromJson(data) as T;
    }
    if (t == _i16.OperationResult) {
      return _i16.OperationResult.fromJson(data) as T;
    }
    if (t == _i17.PagedRequest) {
      return _i17.PagedRequest.fromJson(data) as T;
    }
    if (t == _i18.SecurityEventRow) {
      return _i18.SecurityEventRow.fromJson(data) as T;
    }
    if (t == _i19.FamilyDto) {
      return _i19.FamilyDto.fromJson(data) as T;
    }
    if (t == _i20.FamilyInviteDto) {
      return _i20.FamilyInviteDto.fromJson(data) as T;
    }
    if (t == _i21.FamilyInviteRow) {
      return _i21.FamilyInviteRow.fromJson(data) as T;
    }
    if (t == _i22.FamilyMemberDto) {
      return _i22.FamilyMemberDto.fromJson(data) as T;
    }
    if (t == _i23.FamilyMemberRow) {
      return _i23.FamilyMemberRow.fromJson(data) as T;
    }
    if (t == _i24.FamilyRow) {
      return _i24.FamilyRow.fromJson(data) as T;
    }
    if (t == _i25.Greeting) {
      return _i25.Greeting.fromJson(data) as T;
    }
    if (t == _i26.FamilyListDto) {
      return _i26.FamilyListDto.fromJson(data) as T;
    }
    if (t == _i27.FamilyListRow) {
      return _i27.FamilyListRow.fromJson(data) as T;
    }
    if (t == _i28.ListItemDto) {
      return _i28.ListItemDto.fromJson(data) as T;
    }
    if (t == _i29.ListItemHistoryRow) {
      return _i29.ListItemHistoryRow.fromJson(data) as T;
    }
    if (t == _i30.ListItemRow) {
      return _i30.ListItemRow.fromJson(data) as T;
    }
    if (t == _i31.MediaAttachmentRow) {
      return _i31.MediaAttachmentRow.fromJson(data) as T;
    }
    if (t == _i32.MediaObjectDto) {
      return _i32.MediaObjectDto.fromJson(data) as T;
    }
    if (t == _i33.MediaObjectRow) {
      return _i33.MediaObjectRow.fromJson(data) as T;
    }
    if (t == _i34.UploadSessionDto) {
      return _i34.UploadSessionDto.fromJson(data) as T;
    }
    if (t == _i35.MoneyContributionDto) {
      return _i35.MoneyContributionDto.fromJson(data) as T;
    }
    if (t == _i36.MoneyContributionRow) {
      return _i36.MoneyContributionRow.fromJson(data) as T;
    }
    if (t == _i37.MoneyGoalDto) {
      return _i37.MoneyGoalDto.fromJson(data) as T;
    }
    if (t == _i38.MoneyGoalRow) {
      return _i38.MoneyGoalRow.fromJson(data) as T;
    }
    if (t == _i39.NotificationPreferenceDto) {
      return _i39.NotificationPreferenceDto.fromJson(data) as T;
    }
    if (t == _i40.NotificationPreferenceRow) {
      return _i40.NotificationPreferenceRow.fromJson(data) as T;
    }
    if (t == _i41.PushTokenRow) {
      return _i41.PushTokenRow.fromJson(data) as T;
    }
    if (t == _i42.ReminderDto) {
      return _i42.ReminderDto.fromJson(data) as T;
    }
    if (t == _i43.ReminderRow) {
      return _i43.ReminderRow.fromJson(data) as T;
    }
    if (t == _i44.AccountDeletionRequestRow) {
      return _i44.AccountDeletionRequestRow.fromJson(data) as T;
    }
    if (t == _i45.AccountDeletionStatusDto) {
      return _i45.AccountDeletionStatusDto.fromJson(data) as T;
    }
    if (t == _i46.PrivacyExportJobDto) {
      return _i46.PrivacyExportJobDto.fromJson(data) as T;
    }
    if (t == _i47.PrivacyExportJobRow) {
      return _i47.PrivacyExportJobRow.fromJson(data) as T;
    }
    if (t == _i48.FamilyRealtimeEvent) {
      return _i48.FamilyRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i49.SyncChangeDto) {
      return _i49.SyncChangeDto.fromJson(data) as T;
    }
    if (t == _i50.SyncChangesResponse) {
      return _i50.SyncChangesResponse.fromJson(data) as T;
    }
    if (t == _i51.TaskDto) {
      return _i51.TaskDto.fromJson(data) as T;
    }
    if (t == _i52.TaskHistoryRow) {
      return _i52.TaskHistoryRow.fromJson(data) as T;
    }
    if (t == _i53.TaskRow) {
      return _i53.TaskRow.fromJson(data) as T;
    }
    if (t == _i54.AccountDeletionPayload) {
      return _i54.AccountDeletionPayload.fromJson(data) as T;
    }
    if (t == _i55.MediaCleanupPayload) {
      return _i55.MediaCleanupPayload.fromJson(data) as T;
    }
    if (t == _i56.NotificationsDuePayload) {
      return _i56.NotificationsDuePayload.fromJson(data) as T;
    }
    if (t == _i57.PrivacyExportPayload) {
      return _i57.PrivacyExportPayload.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ProfileDto?>()) {
      return (data != null ? _i5.ProfileDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CalendarEventDto?>()) {
      return (data != null ? _i6.CalendarEventDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CalendarEventOverrideRow?>()) {
      return (data != null ? _i7.CalendarEventOverrideRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.CalendarEventRow?>()) {
      return (data != null ? _i8.CalendarEventRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CalendarInstanceDto?>()) {
      return (data != null ? _i9.CalendarInstanceDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ApiErrorDto?>()) {
      return (data != null ? _i10.ApiErrorDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.AppProfileRow?>()) {
      return (data != null ? _i11.AppProfileRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.AuditLogRow?>()) {
      return (data != null ? _i12.AuditLogRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ChangeFeedRow?>()) {
      return (data != null ? _i13.ChangeFeedRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.IdempotencyKeyRow?>()) {
      return (data != null ? _i14.IdempotencyKeyRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.MutationMeta?>()) {
      return (data != null ? _i15.MutationMeta.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.OperationResult?>()) {
      return (data != null ? _i16.OperationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.PagedRequest?>()) {
      return (data != null ? _i17.PagedRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.SecurityEventRow?>()) {
      return (data != null ? _i18.SecurityEventRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.FamilyDto?>()) {
      return (data != null ? _i19.FamilyDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.FamilyInviteDto?>()) {
      return (data != null ? _i20.FamilyInviteDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.FamilyInviteRow?>()) {
      return (data != null ? _i21.FamilyInviteRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.FamilyMemberDto?>()) {
      return (data != null ? _i22.FamilyMemberDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.FamilyMemberRow?>()) {
      return (data != null ? _i23.FamilyMemberRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.FamilyRow?>()) {
      return (data != null ? _i24.FamilyRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.Greeting?>()) {
      return (data != null ? _i25.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.FamilyListDto?>()) {
      return (data != null ? _i26.FamilyListDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.FamilyListRow?>()) {
      return (data != null ? _i27.FamilyListRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ListItemDto?>()) {
      return (data != null ? _i28.ListItemDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ListItemHistoryRow?>()) {
      return (data != null ? _i29.ListItemHistoryRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.ListItemRow?>()) {
      return (data != null ? _i30.ListItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.MediaAttachmentRow?>()) {
      return (data != null ? _i31.MediaAttachmentRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.MediaObjectDto?>()) {
      return (data != null ? _i32.MediaObjectDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.MediaObjectRow?>()) {
      return (data != null ? _i33.MediaObjectRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.UploadSessionDto?>()) {
      return (data != null ? _i34.UploadSessionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.MoneyContributionDto?>()) {
      return (data != null ? _i35.MoneyContributionDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.MoneyContributionRow?>()) {
      return (data != null ? _i36.MoneyContributionRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.MoneyGoalDto?>()) {
      return (data != null ? _i37.MoneyGoalDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.MoneyGoalRow?>()) {
      return (data != null ? _i38.MoneyGoalRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.NotificationPreferenceDto?>()) {
      return (data != null
              ? _i39.NotificationPreferenceDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i40.NotificationPreferenceRow?>()) {
      return (data != null
              ? _i40.NotificationPreferenceRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i41.PushTokenRow?>()) {
      return (data != null ? _i41.PushTokenRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.ReminderDto?>()) {
      return (data != null ? _i42.ReminderDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ReminderRow?>()) {
      return (data != null ? _i43.ReminderRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.AccountDeletionRequestRow?>()) {
      return (data != null
              ? _i44.AccountDeletionRequestRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i45.AccountDeletionStatusDto?>()) {
      return (data != null
              ? _i45.AccountDeletionStatusDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i46.PrivacyExportJobDto?>()) {
      return (data != null ? _i46.PrivacyExportJobDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.PrivacyExportJobRow?>()) {
      return (data != null ? _i47.PrivacyExportJobRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.FamilyRealtimeEvent?>()) {
      return (data != null ? _i48.FamilyRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.SyncChangeDto?>()) {
      return (data != null ? _i49.SyncChangeDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.SyncChangesResponse?>()) {
      return (data != null ? _i50.SyncChangesResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.TaskDto?>()) {
      return (data != null ? _i51.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.TaskHistoryRow?>()) {
      return (data != null ? _i52.TaskHistoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.TaskRow?>()) {
      return (data != null ? _i53.TaskRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.AccountDeletionPayload?>()) {
      return (data != null ? _i54.AccountDeletionPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.MediaCleanupPayload?>()) {
      return (data != null ? _i55.MediaCleanupPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.NotificationsDuePayload?>()) {
      return (data != null ? _i56.NotificationsDuePayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.PrivacyExportPayload?>()) {
      return (data != null ? _i57.PrivacyExportPayload.fromJson(data) : null)
          as T;
    }
    if (t == List<_i49.SyncChangeDto>) {
      return (data as List)
              .map((e) => deserialize<_i49.SyncChangeDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.CalendarInstanceDto>) {
      return (data as List)
              .map((e) => deserialize<_i58.CalendarInstanceDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i59.FamilyMemberDto>) {
      return (data as List)
              .map((e) => deserialize<_i59.FamilyMemberDto>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i60.ListItemDto>) {
      return (data as List)
              .map((e) => deserialize<_i60.ListItemDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i61.MoneyGoalDto>) {
      return (data as List)
              .map((e) => deserialize<_i61.MoneyGoalDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.TaskDto>) {
      return (data as List).map((e) => deserialize<_i62.TaskDto>(e)).toList()
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
      _i7.CalendarEventOverrideRow => 'CalendarEventOverrideRow',
      _i8.CalendarEventRow => 'CalendarEventRow',
      _i9.CalendarInstanceDto => 'CalendarInstanceDto',
      _i10.ApiErrorDto => 'ApiErrorDto',
      _i11.AppProfileRow => 'AppProfileRow',
      _i12.AuditLogRow => 'AuditLogRow',
      _i13.ChangeFeedRow => 'ChangeFeedRow',
      _i14.IdempotencyKeyRow => 'IdempotencyKeyRow',
      _i15.MutationMeta => 'MutationMeta',
      _i16.OperationResult => 'OperationResult',
      _i17.PagedRequest => 'PagedRequest',
      _i18.SecurityEventRow => 'SecurityEventRow',
      _i19.FamilyDto => 'FamilyDto',
      _i20.FamilyInviteDto => 'FamilyInviteDto',
      _i21.FamilyInviteRow => 'FamilyInviteRow',
      _i22.FamilyMemberDto => 'FamilyMemberDto',
      _i23.FamilyMemberRow => 'FamilyMemberRow',
      _i24.FamilyRow => 'FamilyRow',
      _i25.Greeting => 'Greeting',
      _i26.FamilyListDto => 'FamilyListDto',
      _i27.FamilyListRow => 'FamilyListRow',
      _i28.ListItemDto => 'ListItemDto',
      _i29.ListItemHistoryRow => 'ListItemHistoryRow',
      _i30.ListItemRow => 'ListItemRow',
      _i31.MediaAttachmentRow => 'MediaAttachmentRow',
      _i32.MediaObjectDto => 'MediaObjectDto',
      _i33.MediaObjectRow => 'MediaObjectRow',
      _i34.UploadSessionDto => 'UploadSessionDto',
      _i35.MoneyContributionDto => 'MoneyContributionDto',
      _i36.MoneyContributionRow => 'MoneyContributionRow',
      _i37.MoneyGoalDto => 'MoneyGoalDto',
      _i38.MoneyGoalRow => 'MoneyGoalRow',
      _i39.NotificationPreferenceDto => 'NotificationPreferenceDto',
      _i40.NotificationPreferenceRow => 'NotificationPreferenceRow',
      _i41.PushTokenRow => 'PushTokenRow',
      _i42.ReminderDto => 'ReminderDto',
      _i43.ReminderRow => 'ReminderRow',
      _i44.AccountDeletionRequestRow => 'AccountDeletionRequestRow',
      _i45.AccountDeletionStatusDto => 'AccountDeletionStatusDto',
      _i46.PrivacyExportJobDto => 'PrivacyExportJobDto',
      _i47.PrivacyExportJobRow => 'PrivacyExportJobRow',
      _i48.FamilyRealtimeEvent => 'FamilyRealtimeEvent',
      _i49.SyncChangeDto => 'SyncChangeDto',
      _i50.SyncChangesResponse => 'SyncChangesResponse',
      _i51.TaskDto => 'TaskDto',
      _i52.TaskHistoryRow => 'TaskHistoryRow',
      _i53.TaskRow => 'TaskRow',
      _i54.AccountDeletionPayload => 'AccountDeletionPayload',
      _i55.MediaCleanupPayload => 'MediaCleanupPayload',
      _i56.NotificationsDuePayload => 'NotificationsDuePayload',
      _i57.PrivacyExportPayload => 'PrivacyExportPayload',
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
      case _i7.CalendarEventOverrideRow():
        return 'CalendarEventOverrideRow';
      case _i8.CalendarEventRow():
        return 'CalendarEventRow';
      case _i9.CalendarInstanceDto():
        return 'CalendarInstanceDto';
      case _i10.ApiErrorDto():
        return 'ApiErrorDto';
      case _i11.AppProfileRow():
        return 'AppProfileRow';
      case _i12.AuditLogRow():
        return 'AuditLogRow';
      case _i13.ChangeFeedRow():
        return 'ChangeFeedRow';
      case _i14.IdempotencyKeyRow():
        return 'IdempotencyKeyRow';
      case _i15.MutationMeta():
        return 'MutationMeta';
      case _i16.OperationResult():
        return 'OperationResult';
      case _i17.PagedRequest():
        return 'PagedRequest';
      case _i18.SecurityEventRow():
        return 'SecurityEventRow';
      case _i19.FamilyDto():
        return 'FamilyDto';
      case _i20.FamilyInviteDto():
        return 'FamilyInviteDto';
      case _i21.FamilyInviteRow():
        return 'FamilyInviteRow';
      case _i22.FamilyMemberDto():
        return 'FamilyMemberDto';
      case _i23.FamilyMemberRow():
        return 'FamilyMemberRow';
      case _i24.FamilyRow():
        return 'FamilyRow';
      case _i25.Greeting():
        return 'Greeting';
      case _i26.FamilyListDto():
        return 'FamilyListDto';
      case _i27.FamilyListRow():
        return 'FamilyListRow';
      case _i28.ListItemDto():
        return 'ListItemDto';
      case _i29.ListItemHistoryRow():
        return 'ListItemHistoryRow';
      case _i30.ListItemRow():
        return 'ListItemRow';
      case _i31.MediaAttachmentRow():
        return 'MediaAttachmentRow';
      case _i32.MediaObjectDto():
        return 'MediaObjectDto';
      case _i33.MediaObjectRow():
        return 'MediaObjectRow';
      case _i34.UploadSessionDto():
        return 'UploadSessionDto';
      case _i35.MoneyContributionDto():
        return 'MoneyContributionDto';
      case _i36.MoneyContributionRow():
        return 'MoneyContributionRow';
      case _i37.MoneyGoalDto():
        return 'MoneyGoalDto';
      case _i38.MoneyGoalRow():
        return 'MoneyGoalRow';
      case _i39.NotificationPreferenceDto():
        return 'NotificationPreferenceDto';
      case _i40.NotificationPreferenceRow():
        return 'NotificationPreferenceRow';
      case _i41.PushTokenRow():
        return 'PushTokenRow';
      case _i42.ReminderDto():
        return 'ReminderDto';
      case _i43.ReminderRow():
        return 'ReminderRow';
      case _i44.AccountDeletionRequestRow():
        return 'AccountDeletionRequestRow';
      case _i45.AccountDeletionStatusDto():
        return 'AccountDeletionStatusDto';
      case _i46.PrivacyExportJobDto():
        return 'PrivacyExportJobDto';
      case _i47.PrivacyExportJobRow():
        return 'PrivacyExportJobRow';
      case _i48.FamilyRealtimeEvent():
        return 'FamilyRealtimeEvent';
      case _i49.SyncChangeDto():
        return 'SyncChangeDto';
      case _i50.SyncChangesResponse():
        return 'SyncChangesResponse';
      case _i51.TaskDto():
        return 'TaskDto';
      case _i52.TaskHistoryRow():
        return 'TaskHistoryRow';
      case _i53.TaskRow():
        return 'TaskRow';
      case _i54.AccountDeletionPayload():
        return 'AccountDeletionPayload';
      case _i55.MediaCleanupPayload():
        return 'MediaCleanupPayload';
      case _i56.NotificationsDuePayload():
        return 'NotificationsDuePayload';
      case _i57.PrivacyExportPayload():
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
    if (dataClassName == 'CalendarEventOverrideRow') {
      return deserialize<_i7.CalendarEventOverrideRow>(data['data']);
    }
    if (dataClassName == 'CalendarEventRow') {
      return deserialize<_i8.CalendarEventRow>(data['data']);
    }
    if (dataClassName == 'CalendarInstanceDto') {
      return deserialize<_i9.CalendarInstanceDto>(data['data']);
    }
    if (dataClassName == 'ApiErrorDto') {
      return deserialize<_i10.ApiErrorDto>(data['data']);
    }
    if (dataClassName == 'AppProfileRow') {
      return deserialize<_i11.AppProfileRow>(data['data']);
    }
    if (dataClassName == 'AuditLogRow') {
      return deserialize<_i12.AuditLogRow>(data['data']);
    }
    if (dataClassName == 'ChangeFeedRow') {
      return deserialize<_i13.ChangeFeedRow>(data['data']);
    }
    if (dataClassName == 'IdempotencyKeyRow') {
      return deserialize<_i14.IdempotencyKeyRow>(data['data']);
    }
    if (dataClassName == 'MutationMeta') {
      return deserialize<_i15.MutationMeta>(data['data']);
    }
    if (dataClassName == 'OperationResult') {
      return deserialize<_i16.OperationResult>(data['data']);
    }
    if (dataClassName == 'PagedRequest') {
      return deserialize<_i17.PagedRequest>(data['data']);
    }
    if (dataClassName == 'SecurityEventRow') {
      return deserialize<_i18.SecurityEventRow>(data['data']);
    }
    if (dataClassName == 'FamilyDto') {
      return deserialize<_i19.FamilyDto>(data['data']);
    }
    if (dataClassName == 'FamilyInviteDto') {
      return deserialize<_i20.FamilyInviteDto>(data['data']);
    }
    if (dataClassName == 'FamilyInviteRow') {
      return deserialize<_i21.FamilyInviteRow>(data['data']);
    }
    if (dataClassName == 'FamilyMemberDto') {
      return deserialize<_i22.FamilyMemberDto>(data['data']);
    }
    if (dataClassName == 'FamilyMemberRow') {
      return deserialize<_i23.FamilyMemberRow>(data['data']);
    }
    if (dataClassName == 'FamilyRow') {
      return deserialize<_i24.FamilyRow>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i25.Greeting>(data['data']);
    }
    if (dataClassName == 'FamilyListDto') {
      return deserialize<_i26.FamilyListDto>(data['data']);
    }
    if (dataClassName == 'FamilyListRow') {
      return deserialize<_i27.FamilyListRow>(data['data']);
    }
    if (dataClassName == 'ListItemDto') {
      return deserialize<_i28.ListItemDto>(data['data']);
    }
    if (dataClassName == 'ListItemHistoryRow') {
      return deserialize<_i29.ListItemHistoryRow>(data['data']);
    }
    if (dataClassName == 'ListItemRow') {
      return deserialize<_i30.ListItemRow>(data['data']);
    }
    if (dataClassName == 'MediaAttachmentRow') {
      return deserialize<_i31.MediaAttachmentRow>(data['data']);
    }
    if (dataClassName == 'MediaObjectDto') {
      return deserialize<_i32.MediaObjectDto>(data['data']);
    }
    if (dataClassName == 'MediaObjectRow') {
      return deserialize<_i33.MediaObjectRow>(data['data']);
    }
    if (dataClassName == 'UploadSessionDto') {
      return deserialize<_i34.UploadSessionDto>(data['data']);
    }
    if (dataClassName == 'MoneyContributionDto') {
      return deserialize<_i35.MoneyContributionDto>(data['data']);
    }
    if (dataClassName == 'MoneyContributionRow') {
      return deserialize<_i36.MoneyContributionRow>(data['data']);
    }
    if (dataClassName == 'MoneyGoalDto') {
      return deserialize<_i37.MoneyGoalDto>(data['data']);
    }
    if (dataClassName == 'MoneyGoalRow') {
      return deserialize<_i38.MoneyGoalRow>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceDto') {
      return deserialize<_i39.NotificationPreferenceDto>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceRow') {
      return deserialize<_i40.NotificationPreferenceRow>(data['data']);
    }
    if (dataClassName == 'PushTokenRow') {
      return deserialize<_i41.PushTokenRow>(data['data']);
    }
    if (dataClassName == 'ReminderDto') {
      return deserialize<_i42.ReminderDto>(data['data']);
    }
    if (dataClassName == 'ReminderRow') {
      return deserialize<_i43.ReminderRow>(data['data']);
    }
    if (dataClassName == 'AccountDeletionRequestRow') {
      return deserialize<_i44.AccountDeletionRequestRow>(data['data']);
    }
    if (dataClassName == 'AccountDeletionStatusDto') {
      return deserialize<_i45.AccountDeletionStatusDto>(data['data']);
    }
    if (dataClassName == 'PrivacyExportJobDto') {
      return deserialize<_i46.PrivacyExportJobDto>(data['data']);
    }
    if (dataClassName == 'PrivacyExportJobRow') {
      return deserialize<_i47.PrivacyExportJobRow>(data['data']);
    }
    if (dataClassName == 'FamilyRealtimeEvent') {
      return deserialize<_i48.FamilyRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'SyncChangeDto') {
      return deserialize<_i49.SyncChangeDto>(data['data']);
    }
    if (dataClassName == 'SyncChangesResponse') {
      return deserialize<_i50.SyncChangesResponse>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i51.TaskDto>(data['data']);
    }
    if (dataClassName == 'TaskHistoryRow') {
      return deserialize<_i52.TaskHistoryRow>(data['data']);
    }
    if (dataClassName == 'TaskRow') {
      return deserialize<_i53.TaskRow>(data['data']);
    }
    if (dataClassName == 'AccountDeletionPayload') {
      return deserialize<_i54.AccountDeletionPayload>(data['data']);
    }
    if (dataClassName == 'MediaCleanupPayload') {
      return deserialize<_i55.MediaCleanupPayload>(data['data']);
    }
    if (dataClassName == 'NotificationsDuePayload') {
      return deserialize<_i56.NotificationsDuePayload>(data['data']);
    }
    if (dataClassName == 'PrivacyExportPayload') {
      return deserialize<_i57.PrivacyExportPayload>(data['data']);
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
    switch (t) {
      case _i7.CalendarEventOverrideRow:
        return _i7.CalendarEventOverrideRow.t;
      case _i8.CalendarEventRow:
        return _i8.CalendarEventRow.t;
      case _i11.AppProfileRow:
        return _i11.AppProfileRow.t;
      case _i12.AuditLogRow:
        return _i12.AuditLogRow.t;
      case _i13.ChangeFeedRow:
        return _i13.ChangeFeedRow.t;
      case _i14.IdempotencyKeyRow:
        return _i14.IdempotencyKeyRow.t;
      case _i18.SecurityEventRow:
        return _i18.SecurityEventRow.t;
      case _i21.FamilyInviteRow:
        return _i21.FamilyInviteRow.t;
      case _i23.FamilyMemberRow:
        return _i23.FamilyMemberRow.t;
      case _i24.FamilyRow:
        return _i24.FamilyRow.t;
      case _i27.FamilyListRow:
        return _i27.FamilyListRow.t;
      case _i29.ListItemHistoryRow:
        return _i29.ListItemHistoryRow.t;
      case _i30.ListItemRow:
        return _i30.ListItemRow.t;
      case _i31.MediaAttachmentRow:
        return _i31.MediaAttachmentRow.t;
      case _i33.MediaObjectRow:
        return _i33.MediaObjectRow.t;
      case _i36.MoneyContributionRow:
        return _i36.MoneyContributionRow.t;
      case _i38.MoneyGoalRow:
        return _i38.MoneyGoalRow.t;
      case _i40.NotificationPreferenceRow:
        return _i40.NotificationPreferenceRow.t;
      case _i41.PushTokenRow:
        return _i41.PushTokenRow.t;
      case _i43.ReminderRow:
        return _i43.ReminderRow.t;
      case _i44.AccountDeletionRequestRow:
        return _i44.AccountDeletionRequestRow.t;
      case _i47.PrivacyExportJobRow:
        return _i47.PrivacyExportJobRow.t;
      case _i52.TaskHistoryRow:
        return _i52.TaskHistoryRow.t;
      case _i53.TaskRow:
        return _i53.TaskRow.t;
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
