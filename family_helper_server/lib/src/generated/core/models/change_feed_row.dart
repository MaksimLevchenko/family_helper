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

abstract class ChangeFeedRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ChangeFeedRow._({
    this.id,
    this.familyId,
    required this.feature,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.changedAt,
    required this.tombstone,
    required this.version,
    required this.payloadJson,
  });

  factory ChangeFeedRow({
    int? id,
    int? familyId,
    required String feature,
    required String entityType,
    required int entityId,
    required String operation,
    required DateTime changedAt,
    required bool tombstone,
    required int version,
    required String payloadJson,
  }) = _ChangeFeedRowImpl;

  factory ChangeFeedRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChangeFeedRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int?,
      feature: jsonSerialization['feature'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      operation: jsonSerialization['operation'] as String,
      changedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['changedAt'],
      ),
      tombstone: jsonSerialization['tombstone'] as bool,
      version: jsonSerialization['version'] as int,
      payloadJson: jsonSerialization['payloadJson'] as String,
    );
  }

  static final t = ChangeFeedRowTable();

  static const db = ChangeFeedRowRepository._();

  @override
  int? id;

  int? familyId;

  String feature;

  String entityType;

  int entityId;

  String operation;

  DateTime changedAt;

  bool tombstone;

  int version;

  String payloadJson;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChangeFeedRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChangeFeedRow copyWith({
    int? id,
    int? familyId,
    String? feature,
    String? entityType,
    int? entityId,
    String? operation,
    DateTime? changedAt,
    bool? tombstone,
    int? version,
    String? payloadJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChangeFeedRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'feature': feature,
      'entityType': entityType,
      'entityId': entityId,
      'operation': operation,
      'changedAt': changedAt.toJson(),
      'tombstone': tombstone,
      'version': version,
      'payloadJson': payloadJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChangeFeedRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'feature': feature,
      'entityType': entityType,
      'entityId': entityId,
      'operation': operation,
      'changedAt': changedAt.toJson(),
      'tombstone': tombstone,
      'version': version,
      'payloadJson': payloadJson,
    };
  }

  static ChangeFeedRowInclude include() {
    return ChangeFeedRowInclude._();
  }

  static ChangeFeedRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ChangeFeedRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChangeFeedRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChangeFeedRowTable>? orderByList,
    ChangeFeedRowInclude? include,
  }) {
    return ChangeFeedRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChangeFeedRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChangeFeedRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChangeFeedRowImpl extends ChangeFeedRow {
  _ChangeFeedRowImpl({
    int? id,
    int? familyId,
    required String feature,
    required String entityType,
    required int entityId,
    required String operation,
    required DateTime changedAt,
    required bool tombstone,
    required int version,
    required String payloadJson,
  }) : super._(
         id: id,
         familyId: familyId,
         feature: feature,
         entityType: entityType,
         entityId: entityId,
         operation: operation,
         changedAt: changedAt,
         tombstone: tombstone,
         version: version,
         payloadJson: payloadJson,
       );

  /// Returns a shallow copy of this [ChangeFeedRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChangeFeedRow copyWith({
    Object? id = _Undefined,
    Object? familyId = _Undefined,
    String? feature,
    String? entityType,
    int? entityId,
    String? operation,
    DateTime? changedAt,
    bool? tombstone,
    int? version,
    String? payloadJson,
  }) {
    return ChangeFeedRow(
      id: id is int? ? id : this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      feature: feature ?? this.feature,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      changedAt: changedAt ?? this.changedAt,
      tombstone: tombstone ?? this.tombstone,
      version: version ?? this.version,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }
}

class ChangeFeedRowUpdateTable extends _i1.UpdateTable<ChangeFeedRowTable> {
  ChangeFeedRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int? value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<String, String> feature(String value) => _i1.ColumnValue(
    table.feature,
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

  _i1.ColumnValue<String, String> operation(String value) => _i1.ColumnValue(
    table.operation,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> changedAt(DateTime value) =>
      _i1.ColumnValue(
        table.changedAt,
        value,
      );

  _i1.ColumnValue<bool, bool> tombstone(bool value) => _i1.ColumnValue(
    table.tombstone,
    value,
  );

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
    value,
  );

  _i1.ColumnValue<String, String> payloadJson(String value) => _i1.ColumnValue(
    table.payloadJson,
    value,
  );
}

class ChangeFeedRowTable extends _i1.Table<int?> {
  ChangeFeedRowTable({super.tableRelation}) : super(tableName: 'change_feed') {
    updateTable = ChangeFeedRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    feature = _i1.ColumnString(
      'feature',
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
    operation = _i1.ColumnString(
      'operation',
      this,
    );
    changedAt = _i1.ColumnDateTime(
      'changedAt',
      this,
    );
    tombstone = _i1.ColumnBool(
      'tombstone',
      this,
    );
    version = _i1.ColumnInt(
      'version',
      this,
    );
    payloadJson = _i1.ColumnString(
      'payloadJson',
      this,
    );
  }

  late final ChangeFeedRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  late final _i1.ColumnString feature;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnInt entityId;

  late final _i1.ColumnString operation;

  late final _i1.ColumnDateTime changedAt;

  late final _i1.ColumnBool tombstone;

  late final _i1.ColumnInt version;

  late final _i1.ColumnString payloadJson;

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    feature,
    entityType,
    entityId,
    operation,
    changedAt,
    tombstone,
    version,
    payloadJson,
  ];
}

class ChangeFeedRowInclude extends _i1.IncludeObject {
  ChangeFeedRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ChangeFeedRow.t;
}

class ChangeFeedRowIncludeList extends _i1.IncludeList {
  ChangeFeedRowIncludeList._({
    _i1.WhereExpressionBuilder<ChangeFeedRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChangeFeedRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ChangeFeedRow.t;
}

class ChangeFeedRowRepository {
  const ChangeFeedRowRepository._();

  /// Returns a list of [ChangeFeedRow]s matching the given query parameters.
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
  Future<List<ChangeFeedRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChangeFeedRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChangeFeedRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChangeFeedRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChangeFeedRow>(
      where: where?.call(ChangeFeedRow.t),
      orderBy: orderBy?.call(ChangeFeedRow.t),
      orderByList: orderByList?.call(ChangeFeedRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ChangeFeedRow] matching the given query parameters.
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
  Future<ChangeFeedRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChangeFeedRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChangeFeedRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChangeFeedRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChangeFeedRow>(
      where: where?.call(ChangeFeedRow.t),
      orderBy: orderBy?.call(ChangeFeedRow.t),
      orderByList: orderByList?.call(ChangeFeedRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ChangeFeedRow] by its [id] or null if no such row exists.
  Future<ChangeFeedRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ChangeFeedRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ChangeFeedRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ChangeFeedRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChangeFeedRow>> insert(
    _i1.Session session,
    List<ChangeFeedRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChangeFeedRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChangeFeedRow] and returns the inserted row.
  ///
  /// The returned [ChangeFeedRow] will have its `id` field set.
  Future<ChangeFeedRow> insertRow(
    _i1.Session session,
    ChangeFeedRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChangeFeedRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChangeFeedRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChangeFeedRow>> update(
    _i1.Session session,
    List<ChangeFeedRow> rows, {
    _i1.ColumnSelections<ChangeFeedRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChangeFeedRow>(
      rows,
      columns: columns?.call(ChangeFeedRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChangeFeedRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChangeFeedRow> updateRow(
    _i1.Session session,
    ChangeFeedRow row, {
    _i1.ColumnSelections<ChangeFeedRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChangeFeedRow>(
      row,
      columns: columns?.call(ChangeFeedRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChangeFeedRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChangeFeedRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChangeFeedRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChangeFeedRow>(
      id,
      columnValues: columnValues(ChangeFeedRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChangeFeedRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChangeFeedRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChangeFeedRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ChangeFeedRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChangeFeedRowTable>? orderBy,
    _i1.OrderByListBuilder<ChangeFeedRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChangeFeedRow>(
      columnValues: columnValues(ChangeFeedRow.t.updateTable),
      where: where(ChangeFeedRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChangeFeedRow.t),
      orderByList: orderByList?.call(ChangeFeedRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChangeFeedRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChangeFeedRow>> delete(
    _i1.Session session,
    List<ChangeFeedRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChangeFeedRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChangeFeedRow].
  Future<ChangeFeedRow> deleteRow(
    _i1.Session session,
    ChangeFeedRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChangeFeedRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChangeFeedRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChangeFeedRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChangeFeedRow>(
      where: where(ChangeFeedRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChangeFeedRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChangeFeedRow>(
      where: where?.call(ChangeFeedRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
