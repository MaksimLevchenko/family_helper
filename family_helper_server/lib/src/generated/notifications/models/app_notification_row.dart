/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../core/models/app_profile_row.dart' as _i2;
import '../../family/models/family_row.dart' as _i3;
import 'package:family_helper_server/src/generated/protocol.dart' as _i4;

abstract class AppNotificationRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppNotificationRow._({
    this.id,
    required this.profileId,
    this.profile,
    required this.familyId,
    this.family,
    required this.category,
    required this.title,
    required this.body,
    required this.entityType,
    required this.entityId,
    this.route,
    required this.payloadJson,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.pushedAt,
    required this.pushStatus,
    required this.version,
  });

  factory AppNotificationRow({
    int? id,
    required int profileId,
    _i2.AppProfileRow? profile,
    required int familyId,
    _i3.FamilyRow? family,
    required String category,
    required String title,
    required String body,
    required String entityType,
    required int entityId,
    String? route,
    required String payloadJson,
    required bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? pushedAt,
    required String pushStatus,
    required int version,
  }) = _AppNotificationRowImpl;

  factory AppNotificationRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppNotificationRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AppProfileRow>(
              jsonSerialization['profile'],
            ),
      familyId: jsonSerialization['familyId'] as int,
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.FamilyRow>(
              jsonSerialization['family'],
            ),
      category: jsonSerialization['category'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      route: jsonSerialization['route'] as String?,
      payloadJson: jsonSerialization['payloadJson'] as String,
      isRead: jsonSerialization['isRead'] as bool,
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      pushedAt: jsonSerialization['pushedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['pushedAt']),
      pushStatus: jsonSerialization['pushStatus'] as String,
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = AppNotificationRowTable();

  static const db = AppNotificationRowRepository._();

  @override
  int? id;

  int profileId;

  _i2.AppProfileRow? profile;

  int familyId;

  _i3.FamilyRow? family;

  String category;

  String title;

  String body;

  String entityType;

  int entityId;

  String? route;

  String payloadJson;

  bool isRead;

  DateTime? readAt;

  DateTime createdAt;

  DateTime? pushedAt;

  String pushStatus;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppNotificationRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppNotificationRow copyWith({
    int? id,
    int? profileId,
    _i2.AppProfileRow? profile,
    int? familyId,
    _i3.FamilyRow? family,
    String? category,
    String? title,
    String? body,
    String? entityType,
    int? entityId,
    String? route,
    String? payloadJson,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? pushedAt,
    String? pushStatus,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppNotificationRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'familyId': familyId,
      if (family != null) 'family': family?.toJson(),
      'category': category,
      'title': title,
      'body': body,
      'entityType': entityType,
      'entityId': entityId,
      if (route != null) 'route': route,
      'payloadJson': payloadJson,
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (pushedAt != null) 'pushedAt': pushedAt?.toJson(),
      'pushStatus': pushStatus,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppNotificationRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'familyId': familyId,
      if (family != null) 'family': family?.toJsonForProtocol(),
      'category': category,
      'title': title,
      'body': body,
      'entityType': entityType,
      'entityId': entityId,
      if (route != null) 'route': route,
      'payloadJson': payloadJson,
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (pushedAt != null) 'pushedAt': pushedAt?.toJson(),
      'pushStatus': pushStatus,
      'version': version,
    };
  }

  static AppNotificationRowInclude include({
    _i2.AppProfileRowInclude? profile,
    _i3.FamilyRowInclude? family,
  }) {
    return AppNotificationRowInclude._(
      profile: profile,
      family: family,
    );
  }

  static AppNotificationRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AppNotificationRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppNotificationRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppNotificationRowTable>? orderByList,
    AppNotificationRowInclude? include,
  }) {
    return AppNotificationRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppNotificationRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppNotificationRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppNotificationRowImpl extends AppNotificationRow {
  _AppNotificationRowImpl({
    int? id,
    required int profileId,
    _i2.AppProfileRow? profile,
    required int familyId,
    _i3.FamilyRow? family,
    required String category,
    required String title,
    required String body,
    required String entityType,
    required int entityId,
    String? route,
    required String payloadJson,
    required bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? pushedAt,
    required String pushStatus,
    required int version,
  }) : super._(
         id: id,
         profileId: profileId,
         profile: profile,
         familyId: familyId,
         family: family,
         category: category,
         title: title,
         body: body,
         entityType: entityType,
         entityId: entityId,
         route: route,
         payloadJson: payloadJson,
         isRead: isRead,
         readAt: readAt,
         createdAt: createdAt,
         pushedAt: pushedAt,
         pushStatus: pushStatus,
         version: version,
       );

  /// Returns a shallow copy of this [AppNotificationRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppNotificationRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    int? familyId,
    Object? family = _Undefined,
    String? category,
    String? title,
    String? body,
    String? entityType,
    int? entityId,
    Object? route = _Undefined,
    String? payloadJson,
    bool? isRead,
    Object? readAt = _Undefined,
    DateTime? createdAt,
    Object? pushedAt = _Undefined,
    String? pushStatus,
    int? version,
  }) {
    return AppNotificationRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      profile: profile is _i2.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      familyId: familyId ?? this.familyId,
      family: family is _i3.FamilyRow? ? family : this.family?.copyWith(),
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      route: route is String? ? route : this.route,
      payloadJson: payloadJson ?? this.payloadJson,
      isRead: isRead ?? this.isRead,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      createdAt: createdAt ?? this.createdAt,
      pushedAt: pushedAt is DateTime? ? pushedAt : this.pushedAt,
      pushStatus: pushStatus ?? this.pushStatus,
      version: version ?? this.version,
    );
  }
}

class AppNotificationRowUpdateTable
    extends _i1.UpdateTable<AppNotificationRowTable> {
  AppNotificationRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> body(String value) => _i1.ColumnValue(
    table.body,
    value,
  );

  _i1.ColumnValue<String, String> entityType(String value) => _i1.ColumnValue(
    table.entityType,
    value,
  );

  _i1.ColumnValue<int, int> entityId(int value) => _i1.ColumnValue(
    table.entityId,
    value,
  );

  _i1.ColumnValue<String, String> route(String? value) => _i1.ColumnValue(
    table.route,
    value,
  );

  _i1.ColumnValue<String, String> payloadJson(String value) => _i1.ColumnValue(
    table.payloadJson,
    value,
  );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> readAt(DateTime? value) =>
      _i1.ColumnValue(
        table.readAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> pushedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.pushedAt,
        value,
      );

  _i1.ColumnValue<String, String> pushStatus(String value) => _i1.ColumnValue(
    table.pushStatus,
    value,
  );

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
    value,
  );
}

class AppNotificationRowTable extends _i1.Table<int?> {
  AppNotificationRowTable({super.tableRelation})
    : super(tableName: 'app_notification') {
    updateTable = AppNotificationRowUpdateTable(this);
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    entityType = _i1.ColumnString(
      'entityType',
      this,
    );
    entityId = _i1.ColumnInt(
      'entityId',
      this,
    );
    route = _i1.ColumnString(
      'route',
      this,
    );
    payloadJson = _i1.ColumnString(
      'payloadJson',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
    );
    readAt = _i1.ColumnDateTime(
      'readAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    pushedAt = _i1.ColumnDateTime(
      'pushedAt',
      this,
    );
    pushStatus = _i1.ColumnString(
      'pushStatus',
      this,
    );
    version = _i1.ColumnInt(
      'version',
      this,
    );
  }

  late final AppNotificationRowUpdateTable updateTable;

  late final _i1.ColumnInt profileId;

  _i2.AppProfileRowTable? _profile;

  late final _i1.ColumnInt familyId;

  _i3.FamilyRowTable? _family;

  late final _i1.ColumnString category;

  late final _i1.ColumnString title;

  late final _i1.ColumnString body;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnInt entityId;

  late final _i1.ColumnString route;

  late final _i1.ColumnString payloadJson;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnDateTime readAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime pushedAt;

  late final _i1.ColumnString pushStatus;

  late final _i1.ColumnInt version;

  _i2.AppProfileRowTable get profile {
    if (_profile != null) return _profile!;
    _profile = _i1.createRelationTable(
      relationFieldName: 'profile',
      field: AppNotificationRow.t.profileId,
      foreignField: _i2.AppProfileRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AppProfileRowTable(tableRelation: foreignTableRelation),
    );
    return _profile!;
  }

  _i3.FamilyRowTable get family {
    if (_family != null) return _family!;
    _family = _i1.createRelationTable(
      relationFieldName: 'family',
      field: AppNotificationRow.t.familyId,
      foreignField: _i3.FamilyRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.FamilyRowTable(tableRelation: foreignTableRelation),
    );
    return _family!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    profileId,
    familyId,
    category,
    title,
    body,
    entityType,
    entityId,
    route,
    payloadJson,
    isRead,
    readAt,
    createdAt,
    pushedAt,
    pushStatus,
    version,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'profile') {
      return profile;
    }
    if (relationField == 'family') {
      return family;
    }
    return null;
  }
}

class AppNotificationRowInclude extends _i1.IncludeObject {
  AppNotificationRowInclude._({
    _i2.AppProfileRowInclude? profile,
    _i3.FamilyRowInclude? family,
  }) {
    _profile = profile;
    _family = family;
  }

  _i2.AppProfileRowInclude? _profile;

  _i3.FamilyRowInclude? _family;

  @override
  Map<String, _i1.Include?> get includes => {
    'profile': _profile,
    'family': _family,
  };

  @override
  _i1.Table<int?> get table => AppNotificationRow.t;
}

class AppNotificationRowIncludeList extends _i1.IncludeList {
  AppNotificationRowIncludeList._({
    _i1.WhereExpressionBuilder<AppNotificationRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppNotificationRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppNotificationRow.t;
}

class AppNotificationRowRepository {
  const AppNotificationRowRepository._();

  final attachRow = const AppNotificationRowAttachRowRepository._();

  /// Returns a list of [AppNotificationRow]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AppNotificationRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppNotificationRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppNotificationRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppNotificationRowTable>? orderByList,
    _i1.Transaction? transaction,
    AppNotificationRowInclude? include,
  }) async {
    return session.db.find<AppNotificationRow>(
      where: where?.call(AppNotificationRow.t),
      orderBy: orderBy?.call(AppNotificationRow.t),
      orderByList: orderByList?.call(AppNotificationRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AppNotificationRow] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AppNotificationRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppNotificationRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppNotificationRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppNotificationRowTable>? orderByList,
    _i1.Transaction? transaction,
    AppNotificationRowInclude? include,
  }) async {
    return session.db.findFirstRow<AppNotificationRow>(
      where: where?.call(AppNotificationRow.t),
      orderBy: orderBy?.call(AppNotificationRow.t),
      orderByList: orderByList?.call(AppNotificationRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AppNotificationRow] by its [id] or null if no such row exists.
  Future<AppNotificationRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AppNotificationRowInclude? include,
  }) async {
    return session.db.findById<AppNotificationRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AppNotificationRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AppNotificationRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppNotificationRow>> insert(
    _i1.Session session,
    List<AppNotificationRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppNotificationRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppNotificationRow] and returns the inserted row.
  ///
  /// The returned [AppNotificationRow] will have its `id` field set.
  Future<AppNotificationRow> insertRow(
    _i1.Session session,
    AppNotificationRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppNotificationRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppNotificationRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppNotificationRow>> update(
    _i1.Session session,
    List<AppNotificationRow> rows, {
    _i1.ColumnSelections<AppNotificationRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppNotificationRow>(
      rows,
      columns: columns?.call(AppNotificationRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppNotificationRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppNotificationRow> updateRow(
    _i1.Session session,
    AppNotificationRow row, {
    _i1.ColumnSelections<AppNotificationRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppNotificationRow>(
      row,
      columns: columns?.call(AppNotificationRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppNotificationRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppNotificationRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AppNotificationRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppNotificationRow>(
      id,
      columnValues: columnValues(AppNotificationRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppNotificationRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppNotificationRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppNotificationRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AppNotificationRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppNotificationRowTable>? orderBy,
    _i1.OrderByListBuilder<AppNotificationRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppNotificationRow>(
      columnValues: columnValues(AppNotificationRow.t.updateTable),
      where: where(AppNotificationRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppNotificationRow.t),
      orderByList: orderByList?.call(AppNotificationRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppNotificationRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppNotificationRow>> delete(
    _i1.Session session,
    List<AppNotificationRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppNotificationRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppNotificationRow].
  Future<AppNotificationRow> deleteRow(
    _i1.Session session,
    AppNotificationRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppNotificationRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppNotificationRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppNotificationRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppNotificationRow>(
      where: where(AppNotificationRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppNotificationRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppNotificationRow>(
      where: where?.call(AppNotificationRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AppNotificationRowAttachRowRepository {
  const AppNotificationRowAttachRowRepository._();

  /// Creates a relation between the given [AppNotificationRow] and [AppProfileRow]
  /// by setting the [AppNotificationRow]'s foreign key `profileId` to refer to the [AppProfileRow].
  Future<void> profile(
    _i1.Session session,
    AppNotificationRow appNotificationRow,
    _i2.AppProfileRow profile, {
    _i1.Transaction? transaction,
  }) async {
    if (appNotificationRow.id == null) {
      throw ArgumentError.notNull('appNotificationRow.id');
    }
    if (profile.id == null) {
      throw ArgumentError.notNull('profile.id');
    }

    var $appNotificationRow = appNotificationRow.copyWith(
      profileId: profile.id,
    );
    await session.db.updateRow<AppNotificationRow>(
      $appNotificationRow,
      columns: [AppNotificationRow.t.profileId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AppNotificationRow] and [FamilyRow]
  /// by setting the [AppNotificationRow]'s foreign key `familyId` to refer to the [FamilyRow].
  Future<void> family(
    _i1.Session session,
    AppNotificationRow appNotificationRow,
    _i3.FamilyRow family, {
    _i1.Transaction? transaction,
  }) async {
    if (appNotificationRow.id == null) {
      throw ArgumentError.notNull('appNotificationRow.id');
    }
    if (family.id == null) {
      throw ArgumentError.notNull('family.id');
    }

    var $appNotificationRow = appNotificationRow.copyWith(familyId: family.id);
    await session.db.updateRow<AppNotificationRow>(
      $appNotificationRow,
      columns: [AppNotificationRow.t.familyId],
      transaction: transaction,
    );
  }
}
