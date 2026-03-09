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

abstract class AppProfileRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppProfileRow._({
    this.id,
    required this.authUserId,
    required this.displayName,
    required this.timezone,
    this.avatarMediaId,
    required this.analyticsOptIn,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory AppProfileRow({
    int? id,
    required String authUserId,
    required String displayName,
    required String timezone,
    int? avatarMediaId,
    required bool analyticsOptIn,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _AppProfileRowImpl;

  factory AppProfileRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppProfileRow(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      timezone: jsonSerialization['timezone'] as String,
      avatarMediaId: jsonSerialization['avatarMediaId'] as int?,
      analyticsOptIn: jsonSerialization['analyticsOptIn'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = AppProfileRowTable();

  static const db = AppProfileRowRepository._();

  @override
  int? id;

  String authUserId;

  String displayName;

  String timezone;

  int? avatarMediaId;

  bool analyticsOptIn;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppProfileRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppProfileRow copyWith({
    int? id,
    String? authUserId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppProfileRow',
      if (id != null) 'id': id,
      'authUserId': authUserId,
      'displayName': displayName,
      'timezone': timezone,
      if (avatarMediaId != null) 'avatarMediaId': avatarMediaId,
      'analyticsOptIn': analyticsOptIn,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppProfileRow',
      if (id != null) 'id': id,
      'authUserId': authUserId,
      'displayName': displayName,
      'timezone': timezone,
      if (avatarMediaId != null) 'avatarMediaId': avatarMediaId,
      'analyticsOptIn': analyticsOptIn,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static AppProfileRowInclude include() {
    return AppProfileRowInclude._();
  }

  static AppProfileRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AppProfileRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppProfileRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppProfileRowTable>? orderByList,
    AppProfileRowInclude? include,
  }) {
    return AppProfileRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppProfileRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppProfileRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppProfileRowImpl extends AppProfileRow {
  _AppProfileRowImpl({
    int? id,
    required String authUserId,
    required String displayName,
    required String timezone,
    int? avatarMediaId,
    required bool analyticsOptIn,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         timezone: timezone,
         avatarMediaId: avatarMediaId,
         analyticsOptIn: analyticsOptIn,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [AppProfileRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppProfileRow copyWith({
    Object? id = _Undefined,
    String? authUserId,
    String? displayName,
    String? timezone,
    Object? avatarMediaId = _Undefined,
    bool? analyticsOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return AppProfileRow(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      timezone: timezone ?? this.timezone,
      avatarMediaId: avatarMediaId is int? ? avatarMediaId : this.avatarMediaId,
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class AppProfileRowUpdateTable extends _i1.UpdateTable<AppProfileRowTable> {
  AppProfileRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> authUserId(String value) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
    value,
  );

  _i1.ColumnValue<String, String> timezone(String value) => _i1.ColumnValue(
    table.timezone,
    value,
  );

  _i1.ColumnValue<int, int> avatarMediaId(int? value) => _i1.ColumnValue(
    table.avatarMediaId,
    value,
  );

  _i1.ColumnValue<bool, bool> analyticsOptIn(bool value) => _i1.ColumnValue(
    table.analyticsOptIn,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
    value,
  );
}

class AppProfileRowTable extends _i1.Table<int?> {
  AppProfileRowTable({super.tableRelation}) : super(tableName: 'app_profile') {
    updateTable = AppProfileRowUpdateTable(this);
    authUserId = _i1.ColumnString(
      'authUserId',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    timezone = _i1.ColumnString(
      'timezone',
      this,
    );
    avatarMediaId = _i1.ColumnInt(
      'avatarMediaId',
      this,
    );
    analyticsOptIn = _i1.ColumnBool(
      'analyticsOptIn',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
    version = _i1.ColumnInt(
      'version',
      this,
    );
  }

  late final AppProfileRowUpdateTable updateTable;

  late final _i1.ColumnString authUserId;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString timezone;

  late final _i1.ColumnInt avatarMediaId;

  late final _i1.ColumnBool analyticsOptIn;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    displayName,
    timezone,
    avatarMediaId,
    analyticsOptIn,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class AppProfileRowInclude extends _i1.IncludeObject {
  AppProfileRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppProfileRow.t;
}

class AppProfileRowIncludeList extends _i1.IncludeList {
  AppProfileRowIncludeList._({
    _i1.WhereExpressionBuilder<AppProfileRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppProfileRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppProfileRow.t;
}

class AppProfileRowRepository {
  const AppProfileRowRepository._();

  /// Returns a list of [AppProfileRow]s matching the given query parameters.
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
  Future<List<AppProfileRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppProfileRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppProfileRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppProfileRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AppProfileRow>(
      where: where?.call(AppProfileRow.t),
      orderBy: orderBy?.call(AppProfileRow.t),
      orderByList: orderByList?.call(AppProfileRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AppProfileRow] matching the given query parameters.
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
  Future<AppProfileRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppProfileRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppProfileRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppProfileRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AppProfileRow>(
      where: where?.call(AppProfileRow.t),
      orderBy: orderBy?.call(AppProfileRow.t),
      orderByList: orderByList?.call(AppProfileRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AppProfileRow] by its [id] or null if no such row exists.
  Future<AppProfileRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AppProfileRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AppProfileRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AppProfileRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppProfileRow>> insert(
    _i1.Session session,
    List<AppProfileRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppProfileRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppProfileRow] and returns the inserted row.
  ///
  /// The returned [AppProfileRow] will have its `id` field set.
  Future<AppProfileRow> insertRow(
    _i1.Session session,
    AppProfileRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppProfileRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppProfileRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppProfileRow>> update(
    _i1.Session session,
    List<AppProfileRow> rows, {
    _i1.ColumnSelections<AppProfileRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppProfileRow>(
      rows,
      columns: columns?.call(AppProfileRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppProfileRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppProfileRow> updateRow(
    _i1.Session session,
    AppProfileRow row, {
    _i1.ColumnSelections<AppProfileRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppProfileRow>(
      row,
      columns: columns?.call(AppProfileRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppProfileRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppProfileRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AppProfileRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppProfileRow>(
      id,
      columnValues: columnValues(AppProfileRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppProfileRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppProfileRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppProfileRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppProfileRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppProfileRowTable>? orderBy,
    _i1.OrderByListBuilder<AppProfileRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppProfileRow>(
      columnValues: columnValues(AppProfileRow.t.updateTable),
      where: where(AppProfileRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppProfileRow.t),
      orderByList: orderByList?.call(AppProfileRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppProfileRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppProfileRow>> delete(
    _i1.Session session,
    List<AppProfileRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppProfileRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppProfileRow].
  Future<AppProfileRow> deleteRow(
    _i1.Session session,
    AppProfileRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppProfileRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppProfileRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppProfileRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppProfileRow>(
      where: where(AppProfileRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppProfileRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppProfileRow>(
      where: where?.call(AppProfileRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
