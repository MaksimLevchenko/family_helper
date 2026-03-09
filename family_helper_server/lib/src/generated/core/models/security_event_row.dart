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

abstract class SecurityEventRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SecurityEventRow._({
    this.id,
    required this.authUserId,
    required this.eventType,
    required this.success,
    required this.payloadJson,
    required this.createdAt,
  });

  factory SecurityEventRow({
    int? id,
    required String authUserId,
    required String eventType,
    required bool success,
    required String payloadJson,
    required DateTime createdAt,
  }) = _SecurityEventRowImpl;

  factory SecurityEventRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecurityEventRow(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String,
      eventType: jsonSerialization['eventType'] as String,
      success: jsonSerialization['success'] as bool,
      payloadJson: jsonSerialization['payloadJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = SecurityEventRowTable();

  static const db = SecurityEventRowRepository._();

  @override
  int? id;

  String authUserId;

  String eventType;

  bool success;

  String payloadJson;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SecurityEventRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SecurityEventRow copyWith({
    int? id,
    String? authUserId,
    String? eventType,
    bool? success,
    String? payloadJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SecurityEventRow',
      if (id != null) 'id': id,
      'authUserId': authUserId,
      'eventType': eventType,
      'success': success,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SecurityEventRow',
      if (id != null) 'id': id,
      'authUserId': authUserId,
      'eventType': eventType,
      'success': success,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static SecurityEventRowInclude include() {
    return SecurityEventRowInclude._();
  }

  static SecurityEventRowIncludeList includeList({
    _i1.WhereExpressionBuilder<SecurityEventRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecurityEventRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecurityEventRowTable>? orderByList,
    SecurityEventRowInclude? include,
  }) {
    return SecurityEventRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecurityEventRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SecurityEventRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecurityEventRowImpl extends SecurityEventRow {
  _SecurityEventRowImpl({
    int? id,
    required String authUserId,
    required String eventType,
    required bool success,
    required String payloadJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         eventType: eventType,
         success: success,
         payloadJson: payloadJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SecurityEventRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SecurityEventRow copyWith({
    Object? id = _Undefined,
    String? authUserId,
    String? eventType,
    bool? success,
    String? payloadJson,
    DateTime? createdAt,
  }) {
    return SecurityEventRow(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      eventType: eventType ?? this.eventType,
      success: success ?? this.success,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SecurityEventRowUpdateTable
    extends _i1.UpdateTable<SecurityEventRowTable> {
  SecurityEventRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> authUserId(String value) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<bool, bool> success(bool value) => _i1.ColumnValue(
    table.success,
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

class SecurityEventRowTable extends _i1.Table<int?> {
  SecurityEventRowTable({super.tableRelation})
    : super(tableName: 'security_event') {
    updateTable = SecurityEventRowUpdateTable(this);
    authUserId = _i1.ColumnString(
      'authUserId',
      this,
    );
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    success = _i1.ColumnBool(
      'success',
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

  late final SecurityEventRowUpdateTable updateTable;

  late final _i1.ColumnString authUserId;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnBool success;

  late final _i1.ColumnString payloadJson;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    eventType,
    success,
    payloadJson,
    createdAt,
  ];
}

class SecurityEventRowInclude extends _i1.IncludeObject {
  SecurityEventRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SecurityEventRow.t;
}

class SecurityEventRowIncludeList extends _i1.IncludeList {
  SecurityEventRowIncludeList._({
    _i1.WhereExpressionBuilder<SecurityEventRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SecurityEventRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SecurityEventRow.t;
}

class SecurityEventRowRepository {
  const SecurityEventRowRepository._();

  /// Returns a list of [SecurityEventRow]s matching the given query parameters.
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
  Future<List<SecurityEventRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecurityEventRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecurityEventRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecurityEventRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SecurityEventRow>(
      where: where?.call(SecurityEventRow.t),
      orderBy: orderBy?.call(SecurityEventRow.t),
      orderByList: orderByList?.call(SecurityEventRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SecurityEventRow] matching the given query parameters.
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
  Future<SecurityEventRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecurityEventRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<SecurityEventRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecurityEventRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SecurityEventRow>(
      where: where?.call(SecurityEventRow.t),
      orderBy: orderBy?.call(SecurityEventRow.t),
      orderByList: orderByList?.call(SecurityEventRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SecurityEventRow] by its [id] or null if no such row exists.
  Future<SecurityEventRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SecurityEventRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SecurityEventRow]s in the list and returns the inserted rows.
  ///
  /// The returned [SecurityEventRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SecurityEventRow>> insert(
    _i1.Session session,
    List<SecurityEventRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SecurityEventRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SecurityEventRow] and returns the inserted row.
  ///
  /// The returned [SecurityEventRow] will have its `id` field set.
  Future<SecurityEventRow> insertRow(
    _i1.Session session,
    SecurityEventRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SecurityEventRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SecurityEventRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SecurityEventRow>> update(
    _i1.Session session,
    List<SecurityEventRow> rows, {
    _i1.ColumnSelections<SecurityEventRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SecurityEventRow>(
      rows,
      columns: columns?.call(SecurityEventRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecurityEventRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SecurityEventRow> updateRow(
    _i1.Session session,
    SecurityEventRow row, {
    _i1.ColumnSelections<SecurityEventRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SecurityEventRow>(
      row,
      columns: columns?.call(SecurityEventRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecurityEventRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SecurityEventRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SecurityEventRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SecurityEventRow>(
      id,
      columnValues: columnValues(SecurityEventRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SecurityEventRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SecurityEventRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SecurityEventRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SecurityEventRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecurityEventRowTable>? orderBy,
    _i1.OrderByListBuilder<SecurityEventRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SecurityEventRow>(
      columnValues: columnValues(SecurityEventRow.t.updateTable),
      where: where(SecurityEventRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecurityEventRow.t),
      orderByList: orderByList?.call(SecurityEventRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SecurityEventRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SecurityEventRow>> delete(
    _i1.Session session,
    List<SecurityEventRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SecurityEventRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SecurityEventRow].
  Future<SecurityEventRow> deleteRow(
    _i1.Session session,
    SecurityEventRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SecurityEventRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SecurityEventRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SecurityEventRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SecurityEventRow>(
      where: where(SecurityEventRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecurityEventRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SecurityEventRow>(
      where: where?.call(SecurityEventRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
