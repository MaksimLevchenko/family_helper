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

abstract class TaskRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TaskRow._({
    this.id,
    required this.familyId,
    required this.title,
    this.description,
    required this.isPersonal,
    required this.priority,
    required this.status,
    this.dueAt,
    this.recurrenceMode,
    this.recurrenceRrule,
    this.assigneeProfileId,
    required this.createdByProfileId,
    this.completedAt,
    this.sourceTaskId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory TaskRow({
    int? id,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    required String status,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
    required int createdByProfileId,
    DateTime? completedAt,
    int? sourceTaskId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _TaskRowImpl;

  factory TaskRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      isPersonal: jsonSerialization['isPersonal'] as bool,
      priority: jsonSerialization['priority'] as String,
      status: jsonSerialization['status'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      recurrenceMode: jsonSerialization['recurrenceMode'] as String?,
      recurrenceRrule: jsonSerialization['recurrenceRrule'] as String?,
      assigneeProfileId: jsonSerialization['assigneeProfileId'] as int?,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      sourceTaskId: jsonSerialization['sourceTaskId'] as int?,
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

  static final t = TaskRowTable();

  static const db = TaskRowRepository._();

  @override
  int? id;

  int familyId;

  String title;

  String? description;

  bool isPersonal;

  String priority;

  String status;

  DateTime? dueAt;

  String? recurrenceMode;

  String? recurrenceRrule;

  int? assigneeProfileId;

  int createdByProfileId;

  DateTime? completedAt;

  int? sourceTaskId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TaskRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskRow copyWith({
    int? id,
    int? familyId,
    String? title,
    String? description,
    bool? isPersonal,
    String? priority,
    String? status,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
    int? createdByProfileId,
    DateTime? completedAt,
    int? sourceTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'isPersonal': isPersonal,
      'priority': priority,
      'status': status,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (recurrenceMode != null) 'recurrenceMode': recurrenceMode,
      if (recurrenceRrule != null) 'recurrenceRrule': recurrenceRrule,
      if (assigneeProfileId != null) 'assigneeProfileId': assigneeProfileId,
      'createdByProfileId': createdByProfileId,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (sourceTaskId != null) 'sourceTaskId': sourceTaskId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'isPersonal': isPersonal,
      'priority': priority,
      'status': status,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (recurrenceMode != null) 'recurrenceMode': recurrenceMode,
      if (recurrenceRrule != null) 'recurrenceRrule': recurrenceRrule,
      if (assigneeProfileId != null) 'assigneeProfileId': assigneeProfileId,
      'createdByProfileId': createdByProfileId,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (sourceTaskId != null) 'sourceTaskId': sourceTaskId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static TaskRowInclude include() {
    return TaskRowInclude._();
  }

  static TaskRowIncludeList includeList({
    _i1.WhereExpressionBuilder<TaskRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskRowTable>? orderByList,
    TaskRowInclude? include,
  }) {
    return TaskRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TaskRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskRowImpl extends TaskRow {
  _TaskRowImpl({
    int? id,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    required String status,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
    required int createdByProfileId,
    DateTime? completedAt,
    int? sourceTaskId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         description: description,
         isPersonal: isPersonal,
         priority: priority,
         status: status,
         dueAt: dueAt,
         recurrenceMode: recurrenceMode,
         recurrenceRrule: recurrenceRrule,
         assigneeProfileId: assigneeProfileId,
         createdByProfileId: createdByProfileId,
         completedAt: completedAt,
         sourceTaskId: sourceTaskId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [TaskRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? title,
    Object? description = _Undefined,
    bool? isPersonal,
    String? priority,
    String? status,
    Object? dueAt = _Undefined,
    Object? recurrenceMode = _Undefined,
    Object? recurrenceRrule = _Undefined,
    Object? assigneeProfileId = _Undefined,
    int? createdByProfileId,
    Object? completedAt = _Undefined,
    Object? sourceTaskId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return TaskRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      isPersonal: isPersonal ?? this.isPersonal,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      recurrenceMode: recurrenceMode is String?
          ? recurrenceMode
          : this.recurrenceMode,
      recurrenceRrule: recurrenceRrule is String?
          ? recurrenceRrule
          : this.recurrenceRrule,
      assigneeProfileId: assigneeProfileId is int?
          ? assigneeProfileId
          : this.assigneeProfileId,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      sourceTaskId: sourceTaskId is int? ? sourceTaskId : this.sourceTaskId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class TaskRowUpdateTable extends _i1.UpdateTable<TaskRowTable> {
  TaskRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<bool, bool> isPersonal(bool value) => _i1.ColumnValue(
    table.isPersonal,
    value,
  );

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dueAt(DateTime? value) => _i1.ColumnValue(
    table.dueAt,
    value,
  );

  _i1.ColumnValue<String, String> recurrenceMode(String? value) =>
      _i1.ColumnValue(
        table.recurrenceMode,
        value,
      );

  _i1.ColumnValue<String, String> recurrenceRrule(String? value) =>
      _i1.ColumnValue(
        table.recurrenceRrule,
        value,
      );

  _i1.ColumnValue<int, int> assigneeProfileId(int? value) => _i1.ColumnValue(
    table.assigneeProfileId,
    value,
  );

  _i1.ColumnValue<int, int> createdByProfileId(int value) => _i1.ColumnValue(
    table.createdByProfileId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.completedAt,
        value,
      );

  _i1.ColumnValue<int, int> sourceTaskId(int? value) => _i1.ColumnValue(
    table.sourceTaskId,
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

class TaskRowTable extends _i1.Table<int?> {
  TaskRowTable({super.tableRelation}) : super(tableName: 'task') {
    updateTable = TaskRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    isPersonal = _i1.ColumnBool(
      'isPersonal',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    dueAt = _i1.ColumnDateTime(
      'dueAt',
      this,
    );
    recurrenceMode = _i1.ColumnString(
      'recurrenceMode',
      this,
    );
    recurrenceRrule = _i1.ColumnString(
      'recurrenceRrule',
      this,
    );
    assigneeProfileId = _i1.ColumnInt(
      'assigneeProfileId',
      this,
    );
    createdByProfileId = _i1.ColumnInt(
      'createdByProfileId',
      this,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
    sourceTaskId = _i1.ColumnInt(
      'sourceTaskId',
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

  late final TaskRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnBool isPersonal;

  late final _i1.ColumnString priority;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime dueAt;

  late final _i1.ColumnString recurrenceMode;

  late final _i1.ColumnString recurrenceRrule;

  late final _i1.ColumnInt assigneeProfileId;

  late final _i1.ColumnInt createdByProfileId;

  late final _i1.ColumnDateTime completedAt;

  late final _i1.ColumnInt sourceTaskId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    title,
    description,
    isPersonal,
    priority,
    status,
    dueAt,
    recurrenceMode,
    recurrenceRrule,
    assigneeProfileId,
    createdByProfileId,
    completedAt,
    sourceTaskId,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class TaskRowInclude extends _i1.IncludeObject {
  TaskRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TaskRow.t;
}

class TaskRowIncludeList extends _i1.IncludeList {
  TaskRowIncludeList._({
    _i1.WhereExpressionBuilder<TaskRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TaskRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TaskRow.t;
}

class TaskRowRepository {
  const TaskRowRepository._();

  /// Returns a list of [TaskRow]s matching the given query parameters.
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
  Future<List<TaskRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TaskRow>(
      where: where?.call(TaskRow.t),
      orderBy: orderBy?.call(TaskRow.t),
      orderByList: orderByList?.call(TaskRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TaskRow] matching the given query parameters.
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
  Future<TaskRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<TaskRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TaskRow>(
      where: where?.call(TaskRow.t),
      orderBy: orderBy?.call(TaskRow.t),
      orderByList: orderByList?.call(TaskRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TaskRow] by its [id] or null if no such row exists.
  Future<TaskRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TaskRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TaskRow]s in the list and returns the inserted rows.
  ///
  /// The returned [TaskRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TaskRow>> insert(
    _i1.Session session,
    List<TaskRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TaskRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TaskRow] and returns the inserted row.
  ///
  /// The returned [TaskRow] will have its `id` field set.
  Future<TaskRow> insertRow(
    _i1.Session session,
    TaskRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TaskRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TaskRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TaskRow>> update(
    _i1.Session session,
    List<TaskRow> rows, {
    _i1.ColumnSelections<TaskRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TaskRow>(
      rows,
      columns: columns?.call(TaskRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TaskRow> updateRow(
    _i1.Session session,
    TaskRow row, {
    _i1.ColumnSelections<TaskRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TaskRow>(
      row,
      columns: columns?.call(TaskRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TaskRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TaskRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TaskRow>(
      id,
      columnValues: columnValues(TaskRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TaskRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TaskRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TaskRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TaskRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskRowTable>? orderBy,
    _i1.OrderByListBuilder<TaskRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TaskRow>(
      columnValues: columnValues(TaskRow.t.updateTable),
      where: where(TaskRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskRow.t),
      orderByList: orderByList?.call(TaskRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TaskRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TaskRow>> delete(
    _i1.Session session,
    List<TaskRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TaskRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TaskRow].
  Future<TaskRow> deleteRow(
    _i1.Session session,
    TaskRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TaskRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TaskRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TaskRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TaskRow>(
      where: where(TaskRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TaskRow>(
      where: where?.call(TaskRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
