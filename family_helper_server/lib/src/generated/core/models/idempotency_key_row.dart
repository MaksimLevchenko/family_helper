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

abstract class IdempotencyKeyRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  IdempotencyKeyRow._({
    this.id,
    required this.actorAuthUserId,
    required this.action,
    required this.clientOperationId,
    this.resourceType,
    this.resourceId,
    required this.createdAt,
  });

  factory IdempotencyKeyRow({
    int? id,
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    String? resourceType,
    int? resourceId,
    required DateTime createdAt,
  }) = _IdempotencyKeyRowImpl;

  factory IdempotencyKeyRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return IdempotencyKeyRow(
      id: jsonSerialization['id'] as int?,
      actorAuthUserId: jsonSerialization['actorAuthUserId'] as String,
      action: jsonSerialization['action'] as String,
      clientOperationId: jsonSerialization['clientOperationId'] as String,
      resourceType: jsonSerialization['resourceType'] as String?,
      resourceId: jsonSerialization['resourceId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = IdempotencyKeyRowTable();

  static const db = IdempotencyKeyRowRepository._();

  @override
  int? id;

  String actorAuthUserId;

  String action;

  String clientOperationId;

  String? resourceType;

  int? resourceId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [IdempotencyKeyRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IdempotencyKeyRow copyWith({
    int? id,
    String? actorAuthUserId,
    String? action,
    String? clientOperationId,
    String? resourceType,
    int? resourceId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdempotencyKeyRow',
      if (id != null) 'id': id,
      'actorAuthUserId': actorAuthUserId,
      'action': action,
      'clientOperationId': clientOperationId,
      if (resourceType != null) 'resourceType': resourceType,
      if (resourceId != null) 'resourceId': resourceId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IdempotencyKeyRow',
      if (id != null) 'id': id,
      'actorAuthUserId': actorAuthUserId,
      'action': action,
      'clientOperationId': clientOperationId,
      if (resourceType != null) 'resourceType': resourceType,
      if (resourceId != null) 'resourceId': resourceId,
      'createdAt': createdAt.toJson(),
    };
  }

  static IdempotencyKeyRowInclude include() {
    return IdempotencyKeyRowInclude._();
  }

  static IdempotencyKeyRowIncludeList includeList({
    _i1.WhereExpressionBuilder<IdempotencyKeyRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IdempotencyKeyRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IdempotencyKeyRowTable>? orderByList,
    IdempotencyKeyRowInclude? include,
  }) {
    return IdempotencyKeyRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IdempotencyKeyRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IdempotencyKeyRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IdempotencyKeyRowImpl extends IdempotencyKeyRow {
  _IdempotencyKeyRowImpl({
    int? id,
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    String? resourceType,
    int? resourceId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorAuthUserId: actorAuthUserId,
         action: action,
         clientOperationId: clientOperationId,
         resourceType: resourceType,
         resourceId: resourceId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [IdempotencyKeyRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IdempotencyKeyRow copyWith({
    Object? id = _Undefined,
    String? actorAuthUserId,
    String? action,
    String? clientOperationId,
    Object? resourceType = _Undefined,
    Object? resourceId = _Undefined,
    DateTime? createdAt,
  }) {
    return IdempotencyKeyRow(
      id: id is int? ? id : this.id,
      actorAuthUserId: actorAuthUserId ?? this.actorAuthUserId,
      action: action ?? this.action,
      clientOperationId: clientOperationId ?? this.clientOperationId,
      resourceType: resourceType is String? ? resourceType : this.resourceType,
      resourceId: resourceId is int? ? resourceId : this.resourceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class IdempotencyKeyRowUpdateTable
    extends _i1.UpdateTable<IdempotencyKeyRowTable> {
  IdempotencyKeyRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> actorAuthUserId(String value) =>
      _i1.ColumnValue(
        table.actorAuthUserId,
        value,
      );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<String, String> clientOperationId(String value) =>
      _i1.ColumnValue(
        table.clientOperationId,
        value,
      );

  _i1.ColumnValue<String, String> resourceType(String? value) =>
      _i1.ColumnValue(
        table.resourceType,
        value,
      );

  _i1.ColumnValue<int, int> resourceId(int? value) => _i1.ColumnValue(
    table.resourceId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class IdempotencyKeyRowTable extends _i1.Table<int?> {
  IdempotencyKeyRowTable({super.tableRelation})
    : super(tableName: 'idempotency_key') {
    updateTable = IdempotencyKeyRowUpdateTable(this);
    actorAuthUserId = _i1.ColumnString(
      'actorAuthUserId',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    clientOperationId = _i1.ColumnString(
      'clientOperationId',
      this,
    );
    resourceType = _i1.ColumnString(
      'resourceType',
      this,
    );
    resourceId = _i1.ColumnInt(
      'resourceId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final IdempotencyKeyRowUpdateTable updateTable;

  late final _i1.ColumnString actorAuthUserId;

  late final _i1.ColumnString action;

  late final _i1.ColumnString clientOperationId;

  late final _i1.ColumnString resourceType;

  late final _i1.ColumnInt resourceId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    actorAuthUserId,
    action,
    clientOperationId,
    resourceType,
    resourceId,
    createdAt,
  ];
}

class IdempotencyKeyRowInclude extends _i1.IncludeObject {
  IdempotencyKeyRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => IdempotencyKeyRow.t;
}

class IdempotencyKeyRowIncludeList extends _i1.IncludeList {
  IdempotencyKeyRowIncludeList._({
    _i1.WhereExpressionBuilder<IdempotencyKeyRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IdempotencyKeyRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => IdempotencyKeyRow.t;
}

class IdempotencyKeyRowRepository {
  const IdempotencyKeyRowRepository._();

  /// Returns a list of [IdempotencyKeyRow]s matching the given query parameters.
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
  Future<List<IdempotencyKeyRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IdempotencyKeyRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IdempotencyKeyRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IdempotencyKeyRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<IdempotencyKeyRow>(
      where: where?.call(IdempotencyKeyRow.t),
      orderBy: orderBy?.call(IdempotencyKeyRow.t),
      orderByList: orderByList?.call(IdempotencyKeyRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [IdempotencyKeyRow] matching the given query parameters.
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
  Future<IdempotencyKeyRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IdempotencyKeyRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<IdempotencyKeyRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IdempotencyKeyRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<IdempotencyKeyRow>(
      where: where?.call(IdempotencyKeyRow.t),
      orderBy: orderBy?.call(IdempotencyKeyRow.t),
      orderByList: orderByList?.call(IdempotencyKeyRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [IdempotencyKeyRow] by its [id] or null if no such row exists.
  Future<IdempotencyKeyRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<IdempotencyKeyRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [IdempotencyKeyRow]s in the list and returns the inserted rows.
  ///
  /// The returned [IdempotencyKeyRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<IdempotencyKeyRow>> insert(
    _i1.Session session,
    List<IdempotencyKeyRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<IdempotencyKeyRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [IdempotencyKeyRow] and returns the inserted row.
  ///
  /// The returned [IdempotencyKeyRow] will have its `id` field set.
  Future<IdempotencyKeyRow> insertRow(
    _i1.Session session,
    IdempotencyKeyRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IdempotencyKeyRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IdempotencyKeyRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IdempotencyKeyRow>> update(
    _i1.Session session,
    List<IdempotencyKeyRow> rows, {
    _i1.ColumnSelections<IdempotencyKeyRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IdempotencyKeyRow>(
      rows,
      columns: columns?.call(IdempotencyKeyRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IdempotencyKeyRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IdempotencyKeyRow> updateRow(
    _i1.Session session,
    IdempotencyKeyRow row, {
    _i1.ColumnSelections<IdempotencyKeyRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IdempotencyKeyRow>(
      row,
      columns: columns?.call(IdempotencyKeyRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IdempotencyKeyRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IdempotencyKeyRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<IdempotencyKeyRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<IdempotencyKeyRow>(
      id,
      columnValues: columnValues(IdempotencyKeyRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IdempotencyKeyRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<IdempotencyKeyRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<IdempotencyKeyRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<IdempotencyKeyRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IdempotencyKeyRowTable>? orderBy,
    _i1.OrderByListBuilder<IdempotencyKeyRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<IdempotencyKeyRow>(
      columnValues: columnValues(IdempotencyKeyRow.t.updateTable),
      where: where(IdempotencyKeyRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IdempotencyKeyRow.t),
      orderByList: orderByList?.call(IdempotencyKeyRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [IdempotencyKeyRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IdempotencyKeyRow>> delete(
    _i1.Session session,
    List<IdempotencyKeyRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IdempotencyKeyRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IdempotencyKeyRow].
  Future<IdempotencyKeyRow> deleteRow(
    _i1.Session session,
    IdempotencyKeyRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IdempotencyKeyRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IdempotencyKeyRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IdempotencyKeyRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IdempotencyKeyRow>(
      where: where(IdempotencyKeyRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IdempotencyKeyRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IdempotencyKeyRow>(
      where: where?.call(IdempotencyKeyRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
