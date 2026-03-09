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

abstract class AuditLogRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuditLogRow._({
    this.id,
    this.familyId,
    required this.actorProfileId,
    required this.action,
    required this.payloadJson,
    required this.createdAt,
  });

  factory AuditLogRow({
    int? id,
    int? familyId,
    required int actorProfileId,
    required String action,
    required String payloadJson,
    required DateTime createdAt,
  }) = _AuditLogRowImpl;

  factory AuditLogRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLogRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int?,
      actorProfileId: jsonSerialization['actorProfileId'] as int,
      action: jsonSerialization['action'] as String,
      payloadJson: jsonSerialization['payloadJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AuditLogRowTable();

  static const db = AuditLogRowRepository._();

  @override
  int? id;

  int? familyId;

  int actorProfileId;

  String action;

  String payloadJson;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuditLogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLogRow copyWith({
    int? id,
    int? familyId,
    int? actorProfileId,
    String? action,
    String? payloadJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLogRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'actorProfileId': actorProfileId,
      'action': action,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditLogRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'actorProfileId': actorProfileId,
      'action': action,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static AuditLogRowInclude include() {
    return AuditLogRowInclude._();
  }

  static AuditLogRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AuditLogRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditLogRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditLogRowTable>? orderByList,
    AuditLogRowInclude? include,
  }) {
    return AuditLogRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditLogRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuditLogRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogRowImpl extends AuditLogRow {
  _AuditLogRowImpl({
    int? id,
    int? familyId,
    required int actorProfileId,
    required String action,
    required String payloadJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         actorProfileId: actorProfileId,
         action: action,
         payloadJson: payloadJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditLogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLogRow copyWith({
    Object? id = _Undefined,
    Object? familyId = _Undefined,
    int? actorProfileId,
    String? action,
    String? payloadJson,
    DateTime? createdAt,
  }) {
    return AuditLogRow(
      id: id is int? ? id : this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      actorProfileId: actorProfileId ?? this.actorProfileId,
      action: action ?? this.action,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuditLogRowUpdateTable extends _i1.UpdateTable<AuditLogRowTable> {
  AuditLogRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int? value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<int, int> actorProfileId(int value) => _i1.ColumnValue(
    table.actorProfileId,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<String, String> payloadJson(String value) => _i1.ColumnValue(
    table.payloadJson,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AuditLogRowTable extends _i1.Table<int?> {
  AuditLogRowTable({super.tableRelation}) : super(tableName: 'audit_log') {
    updateTable = AuditLogRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    actorProfileId = _i1.ColumnInt(
      'actorProfileId',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    payloadJson = _i1.ColumnString(
      'payloadJson',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AuditLogRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  late final _i1.ColumnInt actorProfileId;

  late final _i1.ColumnString action;

  late final _i1.ColumnString payloadJson;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    actorProfileId,
    action,
    payloadJson,
    createdAt,
  ];
}

class AuditLogRowInclude extends _i1.IncludeObject {
  AuditLogRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AuditLogRow.t;
}

class AuditLogRowIncludeList extends _i1.IncludeList {
  AuditLogRowIncludeList._({
    _i1.WhereExpressionBuilder<AuditLogRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuditLogRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuditLogRow.t;
}

class AuditLogRowRepository {
  const AuditLogRowRepository._();

  /// Returns a list of [AuditLogRow]s matching the given query parameters.
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
  Future<List<AuditLogRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuditLogRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditLogRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditLogRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AuditLogRow>(
      where: where?.call(AuditLogRow.t),
      orderBy: orderBy?.call(AuditLogRow.t),
      orderByList: orderByList?.call(AuditLogRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AuditLogRow] matching the given query parameters.
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
  Future<AuditLogRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuditLogRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuditLogRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditLogRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AuditLogRow>(
      where: where?.call(AuditLogRow.t),
      orderBy: orderBy?.call(AuditLogRow.t),
      orderByList: orderByList?.call(AuditLogRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AuditLogRow] by its [id] or null if no such row exists.
  Future<AuditLogRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AuditLogRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AuditLogRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AuditLogRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuditLogRow>> insert(
    _i1.Session session,
    List<AuditLogRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuditLogRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuditLogRow] and returns the inserted row.
  ///
  /// The returned [AuditLogRow] will have its `id` field set.
  Future<AuditLogRow> insertRow(
    _i1.Session session,
    AuditLogRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuditLogRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuditLogRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuditLogRow>> update(
    _i1.Session session,
    List<AuditLogRow> rows, {
    _i1.ColumnSelections<AuditLogRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuditLogRow>(
      rows,
      columns: columns?.call(AuditLogRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditLogRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuditLogRow> updateRow(
    _i1.Session session,
    AuditLogRow row, {
    _i1.ColumnSelections<AuditLogRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuditLogRow>(
      row,
      columns: columns?.call(AuditLogRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditLogRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuditLogRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AuditLogRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AuditLogRow>(
      id,
      columnValues: columnValues(AuditLogRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuditLogRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AuditLogRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AuditLogRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AuditLogRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditLogRowTable>? orderBy,
    _i1.OrderByListBuilder<AuditLogRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AuditLogRow>(
      columnValues: columnValues(AuditLogRow.t.updateTable),
      where: where(AuditLogRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditLogRow.t),
      orderByList: orderByList?.call(AuditLogRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AuditLogRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuditLogRow>> delete(
    _i1.Session session,
    List<AuditLogRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuditLogRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuditLogRow].
  Future<AuditLogRow> deleteRow(
    _i1.Session session,
    AuditLogRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuditLogRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuditLogRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuditLogRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuditLogRow>(
      where: where(AuditLogRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuditLogRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuditLogRow>(
      where: where?.call(AuditLogRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
