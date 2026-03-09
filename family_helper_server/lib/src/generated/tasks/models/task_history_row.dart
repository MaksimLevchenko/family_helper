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

abstract class TaskHistoryRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TaskHistoryRow._({
    this.id,
    required this.taskId,
    required this.actorProfileId,
    required this.eventType,
    this.details,
    required this.createdAt,
  });

  factory TaskHistoryRow({
    int? id,
    required int taskId,
    required int actorProfileId,
    required String eventType,
    String? details,
    required DateTime createdAt,
  }) = _TaskHistoryRowImpl;

  factory TaskHistoryRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskHistoryRow(
      id: jsonSerialization['id'] as int?,
      taskId: jsonSerialization['taskId'] as int,
      actorProfileId: jsonSerialization['actorProfileId'] as int,
      eventType: jsonSerialization['eventType'] as String,
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TaskHistoryRowTable();

  static const db = TaskHistoryRowRepository._();

  @override
  int? id;

  int taskId;

  int actorProfileId;

  String eventType;

  String? details;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TaskHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskHistoryRow copyWith({
    int? id,
    int? taskId,
    int? actorProfileId,
    String? eventType,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskHistoryRow',
      if (id != null) 'id': id,
      'taskId': taskId,
      'actorProfileId': actorProfileId,
      'eventType': eventType,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskHistoryRow',
      if (id != null) 'id': id,
      'taskId': taskId,
      'actorProfileId': actorProfileId,
      'eventType': eventType,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  static TaskHistoryRowInclude include() {
    return TaskHistoryRowInclude._();
  }

  static TaskHistoryRowIncludeList includeList({
    _i1.WhereExpressionBuilder<TaskHistoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskHistoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskHistoryRowTable>? orderByList,
    TaskHistoryRowInclude? include,
  }) {
    return TaskHistoryRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskHistoryRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TaskHistoryRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskHistoryRowImpl extends TaskHistoryRow {
  _TaskHistoryRowImpl({
    int? id,
    required int taskId,
    required int actorProfileId,
    required String eventType,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         taskId: taskId,
         actorProfileId: actorProfileId,
         eventType: eventType,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaskHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskHistoryRow copyWith({
    Object? id = _Undefined,
    int? taskId,
    int? actorProfileId,
    String? eventType,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return TaskHistoryRow(
      id: id is int? ? id : this.id,
      taskId: taskId ?? this.taskId,
      actorProfileId: actorProfileId ?? this.actorProfileId,
      eventType: eventType ?? this.eventType,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TaskHistoryRowUpdateTable extends _i1.UpdateTable<TaskHistoryRowTable> {
  TaskHistoryRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> taskId(int value) => _i1.ColumnValue(
    table.taskId,
    value,
  );

  _i1.ColumnValue<int, int> actorProfileId(int value) => _i1.ColumnValue(
    table.actorProfileId,
    value,
  );

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<String, String> details(String? value) => _i1.ColumnValue(
    table.details,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TaskHistoryRowTable extends _i1.Table<int?> {
  TaskHistoryRowTable({super.tableRelation})
    : super(tableName: 'task_history') {
    updateTable = TaskHistoryRowUpdateTable(this);
    taskId = _i1.ColumnInt(
      'taskId',
      this,
    );
    actorProfileId = _i1.ColumnInt(
      'actorProfileId',
      this,
    );
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    details = _i1.ColumnString(
      'details',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TaskHistoryRowUpdateTable updateTable;

  late final _i1.ColumnInt taskId;

  late final _i1.ColumnInt actorProfileId;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnString details;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    taskId,
    actorProfileId,
    eventType,
    details,
    createdAt,
  ];
}

class TaskHistoryRowInclude extends _i1.IncludeObject {
  TaskHistoryRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TaskHistoryRow.t;
}

class TaskHistoryRowIncludeList extends _i1.IncludeList {
  TaskHistoryRowIncludeList._({
    _i1.WhereExpressionBuilder<TaskHistoryRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TaskHistoryRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TaskHistoryRow.t;
}

class TaskHistoryRowRepository {
  const TaskHistoryRowRepository._();

  /// Returns a list of [TaskHistoryRow]s matching the given query parameters.
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
  Future<List<TaskHistoryRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskHistoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskHistoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskHistoryRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TaskHistoryRow>(
      where: where?.call(TaskHistoryRow.t),
      orderBy: orderBy?.call(TaskHistoryRow.t),
      orderByList: orderByList?.call(TaskHistoryRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TaskHistoryRow] matching the given query parameters.
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
  Future<TaskHistoryRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskHistoryRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<TaskHistoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskHistoryRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TaskHistoryRow>(
      where: where?.call(TaskHistoryRow.t),
      orderBy: orderBy?.call(TaskHistoryRow.t),
      orderByList: orderByList?.call(TaskHistoryRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TaskHistoryRow] by its [id] or null if no such row exists.
  Future<TaskHistoryRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TaskHistoryRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TaskHistoryRow]s in the list and returns the inserted rows.
  ///
  /// The returned [TaskHistoryRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TaskHistoryRow>> insert(
    _i1.Session session,
    List<TaskHistoryRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TaskHistoryRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TaskHistoryRow] and returns the inserted row.
  ///
  /// The returned [TaskHistoryRow] will have its `id` field set.
  Future<TaskHistoryRow> insertRow(
    _i1.Session session,
    TaskHistoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TaskHistoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TaskHistoryRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TaskHistoryRow>> update(
    _i1.Session session,
    List<TaskHistoryRow> rows, {
    _i1.ColumnSelections<TaskHistoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TaskHistoryRow>(
      rows,
      columns: columns?.call(TaskHistoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskHistoryRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TaskHistoryRow> updateRow(
    _i1.Session session,
    TaskHistoryRow row, {
    _i1.ColumnSelections<TaskHistoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TaskHistoryRow>(
      row,
      columns: columns?.call(TaskHistoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskHistoryRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TaskHistoryRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TaskHistoryRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TaskHistoryRow>(
      id,
      columnValues: columnValues(TaskHistoryRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TaskHistoryRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TaskHistoryRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TaskHistoryRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TaskHistoryRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskHistoryRowTable>? orderBy,
    _i1.OrderByListBuilder<TaskHistoryRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TaskHistoryRow>(
      columnValues: columnValues(TaskHistoryRow.t.updateTable),
      where: where(TaskHistoryRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskHistoryRow.t),
      orderByList: orderByList?.call(TaskHistoryRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TaskHistoryRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TaskHistoryRow>> delete(
    _i1.Session session,
    List<TaskHistoryRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TaskHistoryRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TaskHistoryRow].
  Future<TaskHistoryRow> deleteRow(
    _i1.Session session,
    TaskHistoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TaskHistoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TaskHistoryRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TaskHistoryRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TaskHistoryRow>(
      where: where(TaskHistoryRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskHistoryRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TaskHistoryRow>(
      where: where?.call(TaskHistoryRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
