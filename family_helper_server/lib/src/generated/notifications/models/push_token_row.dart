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

abstract class PushTokenRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PushTokenRow._({
    this.id,
    required this.profileId,
    required this.token,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory PushTokenRow({
    int? id,
    required int profileId,
    required String token,
    required String platform,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _PushTokenRowImpl;

  factory PushTokenRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushTokenRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      token: jsonSerialization['token'] as String,
      platform: jsonSerialization['platform'] as String,
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

  static final t = PushTokenRowTable();

  static const db = PushTokenRowRepository._();

  @override
  int? id;

  int profileId;

  String token;

  String platform;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PushTokenRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PushTokenRow copyWith({
    int? id,
    int? profileId,
    String? token,
    String? platform,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushTokenRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'token': token,
      'platform': platform,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushTokenRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'token': token,
      'platform': platform,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static PushTokenRowInclude include() {
    return PushTokenRowInclude._();
  }

  static PushTokenRowIncludeList includeList({
    _i1.WhereExpressionBuilder<PushTokenRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PushTokenRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PushTokenRowTable>? orderByList,
    PushTokenRowInclude? include,
  }) {
    return PushTokenRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushTokenRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PushTokenRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushTokenRowImpl extends PushTokenRow {
  _PushTokenRowImpl({
    int? id,
    required int profileId,
    required String token,
    required String platform,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         profileId: profileId,
         token: token,
         platform: platform,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [PushTokenRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PushTokenRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? token,
    String? platform,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return PushTokenRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class PushTokenRowUpdateTable extends _i1.UpdateTable<PushTokenRowTable> {
  PushTokenRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<String, String> token(String value) => _i1.ColumnValue(
    table.token,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
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

class PushTokenRowTable extends _i1.Table<int?> {
  PushTokenRowTable({super.tableRelation}) : super(tableName: 'push_token') {
    updateTable = PushTokenRowUpdateTable(this);
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
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

  late final PushTokenRowUpdateTable updateTable;

  late final _i1.ColumnInt profileId;

  late final _i1.ColumnString token;

  late final _i1.ColumnString platform;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    profileId,
    token,
    platform,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class PushTokenRowInclude extends _i1.IncludeObject {
  PushTokenRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PushTokenRow.t;
}

class PushTokenRowIncludeList extends _i1.IncludeList {
  PushTokenRowIncludeList._({
    _i1.WhereExpressionBuilder<PushTokenRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushTokenRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PushTokenRow.t;
}

class PushTokenRowRepository {
  const PushTokenRowRepository._();

  /// Returns a list of [PushTokenRow]s matching the given query parameters.
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
  Future<List<PushTokenRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PushTokenRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PushTokenRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PushTokenRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PushTokenRow>(
      where: where?.call(PushTokenRow.t),
      orderBy: orderBy?.call(PushTokenRow.t),
      orderByList: orderByList?.call(PushTokenRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PushTokenRow] matching the given query parameters.
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
  Future<PushTokenRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PushTokenRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<PushTokenRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PushTokenRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PushTokenRow>(
      where: where?.call(PushTokenRow.t),
      orderBy: orderBy?.call(PushTokenRow.t),
      orderByList: orderByList?.call(PushTokenRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PushTokenRow] by its [id] or null if no such row exists.
  Future<PushTokenRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PushTokenRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PushTokenRow]s in the list and returns the inserted rows.
  ///
  /// The returned [PushTokenRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PushTokenRow>> insert(
    _i1.Session session,
    List<PushTokenRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PushTokenRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PushTokenRow] and returns the inserted row.
  ///
  /// The returned [PushTokenRow] will have its `id` field set.
  Future<PushTokenRow> insertRow(
    _i1.Session session,
    PushTokenRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushTokenRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PushTokenRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PushTokenRow>> update(
    _i1.Session session,
    List<PushTokenRow> rows, {
    _i1.ColumnSelections<PushTokenRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PushTokenRow>(
      rows,
      columns: columns?.call(PushTokenRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushTokenRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushTokenRow> updateRow(
    _i1.Session session,
    PushTokenRow row, {
    _i1.ColumnSelections<PushTokenRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushTokenRow>(
      row,
      columns: columns?.call(PushTokenRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushTokenRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushTokenRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PushTokenRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PushTokenRow>(
      id,
      columnValues: columnValues(PushTokenRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushTokenRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PushTokenRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PushTokenRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PushTokenRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PushTokenRowTable>? orderBy,
    _i1.OrderByListBuilder<PushTokenRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PushTokenRow>(
      columnValues: columnValues(PushTokenRow.t.updateTable),
      where: where(PushTokenRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushTokenRow.t),
      orderByList: orderByList?.call(PushTokenRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PushTokenRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PushTokenRow>> delete(
    _i1.Session session,
    List<PushTokenRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PushTokenRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PushTokenRow].
  Future<PushTokenRow> deleteRow(
    _i1.Session session,
    PushTokenRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushTokenRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PushTokenRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PushTokenRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PushTokenRow>(
      where: where(PushTokenRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PushTokenRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PushTokenRow>(
      where: where?.call(PushTokenRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
