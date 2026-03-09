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

abstract class CalendarEventOverrideRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CalendarEventOverrideRow._({
    this.id,
    required this.eventId,
    required this.occurrenceStart,
    this.overrideTitle,
    this.overrideStartsAt,
    this.overrideEndsAt,
    required this.cancelled,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory CalendarEventOverrideRow({
    int? id,
    required int eventId,
    required DateTime occurrenceStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    required bool cancelled,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _CalendarEventOverrideRowImpl;

  factory CalendarEventOverrideRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CalendarEventOverrideRow(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      occurrenceStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceStart'],
      ),
      overrideTitle: jsonSerialization['overrideTitle'] as String?,
      overrideStartsAt: jsonSerialization['overrideStartsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['overrideStartsAt'],
            ),
      overrideEndsAt: jsonSerialization['overrideEndsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['overrideEndsAt'],
            ),
      cancelled: jsonSerialization['cancelled'] as bool,
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

  static final t = CalendarEventOverrideRowTable();

  static const db = CalendarEventOverrideRowRepository._();

  @override
  int? id;

  int eventId;

  DateTime occurrenceStart;

  String? overrideTitle;

  DateTime? overrideStartsAt;

  DateTime? overrideEndsAt;

  bool cancelled;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CalendarEventOverrideRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarEventOverrideRow copyWith({
    int? id,
    int? eventId,
    DateTime? occurrenceStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    bool? cancelled,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarEventOverrideRow',
      if (id != null) 'id': id,
      'eventId': eventId,
      'occurrenceStart': occurrenceStart.toJson(),
      if (overrideTitle != null) 'overrideTitle': overrideTitle,
      if (overrideStartsAt != null)
        'overrideStartsAt': overrideStartsAt?.toJson(),
      if (overrideEndsAt != null) 'overrideEndsAt': overrideEndsAt?.toJson(),
      'cancelled': cancelled,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarEventOverrideRow',
      if (id != null) 'id': id,
      'eventId': eventId,
      'occurrenceStart': occurrenceStart.toJson(),
      if (overrideTitle != null) 'overrideTitle': overrideTitle,
      if (overrideStartsAt != null)
        'overrideStartsAt': overrideStartsAt?.toJson(),
      if (overrideEndsAt != null) 'overrideEndsAt': overrideEndsAt?.toJson(),
      'cancelled': cancelled,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static CalendarEventOverrideRowInclude include() {
    return CalendarEventOverrideRowInclude._();
  }

  static CalendarEventOverrideRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventOverrideRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventOverrideRowTable>? orderByList,
    CalendarEventOverrideRowInclude? include,
  }) {
    return CalendarEventOverrideRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventOverrideRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CalendarEventOverrideRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarEventOverrideRowImpl extends CalendarEventOverrideRow {
  _CalendarEventOverrideRowImpl({
    int? id,
    required int eventId,
    required DateTime occurrenceStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    required bool cancelled,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         eventId: eventId,
         occurrenceStart: occurrenceStart,
         overrideTitle: overrideTitle,
         overrideStartsAt: overrideStartsAt,
         overrideEndsAt: overrideEndsAt,
         cancelled: cancelled,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CalendarEventOverrideRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarEventOverrideRow copyWith({
    Object? id = _Undefined,
    int? eventId,
    DateTime? occurrenceStart,
    Object? overrideTitle = _Undefined,
    Object? overrideStartsAt = _Undefined,
    Object? overrideEndsAt = _Undefined,
    bool? cancelled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return CalendarEventOverrideRow(
      id: id is int? ? id : this.id,
      eventId: eventId ?? this.eventId,
      occurrenceStart: occurrenceStart ?? this.occurrenceStart,
      overrideTitle: overrideTitle is String?
          ? overrideTitle
          : this.overrideTitle,
      overrideStartsAt: overrideStartsAt is DateTime?
          ? overrideStartsAt
          : this.overrideStartsAt,
      overrideEndsAt: overrideEndsAt is DateTime?
          ? overrideEndsAt
          : this.overrideEndsAt,
      cancelled: cancelled ?? this.cancelled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class CalendarEventOverrideRowUpdateTable
    extends _i1.UpdateTable<CalendarEventOverrideRowTable> {
  CalendarEventOverrideRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> eventId(int value) => _i1.ColumnValue(
    table.eventId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> occurrenceStart(DateTime value) =>
      _i1.ColumnValue(
        table.occurrenceStart,
        value,
      );

  _i1.ColumnValue<String, String> overrideTitle(String? value) =>
      _i1.ColumnValue(
        table.overrideTitle,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> overrideStartsAt(DateTime? value) =>
      _i1.ColumnValue(
        table.overrideStartsAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> overrideEndsAt(DateTime? value) =>
      _i1.ColumnValue(
        table.overrideEndsAt,
        value,
      );

  _i1.ColumnValue<bool, bool> cancelled(bool value) => _i1.ColumnValue(
    table.cancelled,
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

class CalendarEventOverrideRowTable extends _i1.Table<int?> {
  CalendarEventOverrideRowTable({super.tableRelation})
    : super(tableName: 'calendar_event_override') {
    updateTable = CalendarEventOverrideRowUpdateTable(this);
    eventId = _i1.ColumnInt(
      'eventId',
      this,
    );
    occurrenceStart = _i1.ColumnDateTime(
      'occurrenceStart',
      this,
    );
    overrideTitle = _i1.ColumnString(
      'overrideTitle',
      this,
    );
    overrideStartsAt = _i1.ColumnDateTime(
      'overrideStartsAt',
      this,
    );
    overrideEndsAt = _i1.ColumnDateTime(
      'overrideEndsAt',
      this,
    );
    cancelled = _i1.ColumnBool(
      'cancelled',
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

  late final CalendarEventOverrideRowUpdateTable updateTable;

  late final _i1.ColumnInt eventId;

  late final _i1.ColumnDateTime occurrenceStart;

  late final _i1.ColumnString overrideTitle;

  late final _i1.ColumnDateTime overrideStartsAt;

  late final _i1.ColumnDateTime overrideEndsAt;

  late final _i1.ColumnBool cancelled;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    eventId,
    occurrenceStart,
    overrideTitle,
    overrideStartsAt,
    overrideEndsAt,
    cancelled,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class CalendarEventOverrideRowInclude extends _i1.IncludeObject {
  CalendarEventOverrideRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CalendarEventOverrideRow.t;
}

class CalendarEventOverrideRowIncludeList extends _i1.IncludeList {
  CalendarEventOverrideRowIncludeList._({
    _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CalendarEventOverrideRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CalendarEventOverrideRow.t;
}

class CalendarEventOverrideRowRepository {
  const CalendarEventOverrideRowRepository._();

  /// Returns a list of [CalendarEventOverrideRow]s matching the given query parameters.
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
  Future<List<CalendarEventOverrideRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventOverrideRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventOverrideRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CalendarEventOverrideRow>(
      where: where?.call(CalendarEventOverrideRow.t),
      orderBy: orderBy?.call(CalendarEventOverrideRow.t),
      orderByList: orderByList?.call(CalendarEventOverrideRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CalendarEventOverrideRow] matching the given query parameters.
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
  Future<CalendarEventOverrideRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CalendarEventOverrideRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventOverrideRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CalendarEventOverrideRow>(
      where: where?.call(CalendarEventOverrideRow.t),
      orderBy: orderBy?.call(CalendarEventOverrideRow.t),
      orderByList: orderByList?.call(CalendarEventOverrideRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CalendarEventOverrideRow] by its [id] or null if no such row exists.
  Future<CalendarEventOverrideRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CalendarEventOverrideRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CalendarEventOverrideRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CalendarEventOverrideRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CalendarEventOverrideRow>> insert(
    _i1.Session session,
    List<CalendarEventOverrideRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CalendarEventOverrideRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CalendarEventOverrideRow] and returns the inserted row.
  ///
  /// The returned [CalendarEventOverrideRow] will have its `id` field set.
  Future<CalendarEventOverrideRow> insertRow(
    _i1.Session session,
    CalendarEventOverrideRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CalendarEventOverrideRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventOverrideRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CalendarEventOverrideRow>> update(
    _i1.Session session,
    List<CalendarEventOverrideRow> rows, {
    _i1.ColumnSelections<CalendarEventOverrideRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CalendarEventOverrideRow>(
      rows,
      columns: columns?.call(CalendarEventOverrideRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarEventOverrideRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CalendarEventOverrideRow> updateRow(
    _i1.Session session,
    CalendarEventOverrideRow row, {
    _i1.ColumnSelections<CalendarEventOverrideRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CalendarEventOverrideRow>(
      row,
      columns: columns?.call(CalendarEventOverrideRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarEventOverrideRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CalendarEventOverrideRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CalendarEventOverrideRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CalendarEventOverrideRow>(
      id,
      columnValues: columnValues(CalendarEventOverrideRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventOverrideRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CalendarEventOverrideRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CalendarEventOverrideRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventOverrideRowTable>? orderBy,
    _i1.OrderByListBuilder<CalendarEventOverrideRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CalendarEventOverrideRow>(
      columnValues: columnValues(CalendarEventOverrideRow.t.updateTable),
      where: where(CalendarEventOverrideRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventOverrideRow.t),
      orderByList: orderByList?.call(CalendarEventOverrideRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CalendarEventOverrideRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CalendarEventOverrideRow>> delete(
    _i1.Session session,
    List<CalendarEventOverrideRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CalendarEventOverrideRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CalendarEventOverrideRow].
  Future<CalendarEventOverrideRow> deleteRow(
    _i1.Session session,
    CalendarEventOverrideRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CalendarEventOverrideRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CalendarEventOverrideRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CalendarEventOverrideRow>(
      where: where(CalendarEventOverrideRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventOverrideRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CalendarEventOverrideRow>(
      where: where?.call(CalendarEventOverrideRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
