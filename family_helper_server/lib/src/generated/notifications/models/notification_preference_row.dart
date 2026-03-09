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

abstract class NotificationPreferenceRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NotificationPreferenceRow._({
    this.id,
    required this.profileId,
    required this.notificationType,
    required this.enabled,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.updatedAt,
    required this.version,
  });

  factory NotificationPreferenceRow({
    int? id,
    required int profileId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime updatedAt,
    required int version,
  }) = _NotificationPreferenceRowImpl;

  factory NotificationPreferenceRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreferenceRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      notificationType: jsonSerialization['notificationType'] as String,
      enabled: jsonSerialization['enabled'] as bool,
      quietHoursStart: jsonSerialization['quietHoursStart'] as String?,
      quietHoursEnd: jsonSerialization['quietHoursEnd'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = NotificationPreferenceRowTable();

  static const db = NotificationPreferenceRowRepository._();

  @override
  int? id;

  int profileId;

  String notificationType;

  bool enabled;

  String? quietHoursStart;

  String? quietHoursEnd;

  DateTime updatedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationPreferenceRow copyWith({
    int? id,
    int? profileId,
    String? notificationType,
    bool? enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreferenceRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'notificationType': notificationType,
      'enabled': enabled,
      if (quietHoursStart != null) 'quietHoursStart': quietHoursStart,
      if (quietHoursEnd != null) 'quietHoursEnd': quietHoursEnd,
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationPreferenceRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'notificationType': notificationType,
      'enabled': enabled,
      if (quietHoursStart != null) 'quietHoursStart': quietHoursStart,
      if (quietHoursEnd != null) 'quietHoursEnd': quietHoursEnd,
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static NotificationPreferenceRowInclude include() {
    return NotificationPreferenceRowInclude._();
  }

  static NotificationPreferenceRowIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    NotificationPreferenceRowInclude? include,
  }) {
    return NotificationPreferenceRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceRowImpl extends NotificationPreferenceRow {
  _NotificationPreferenceRowImpl({
    int? id,
    required int profileId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         profileId: profileId,
         notificationType: notificationType,
         enabled: enabled,
         quietHoursStart: quietHoursStart,
         quietHoursEnd: quietHoursEnd,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [NotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationPreferenceRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? notificationType,
    bool? enabled,
    Object? quietHoursStart = _Undefined,
    Object? quietHoursEnd = _Undefined,
    DateTime? updatedAt,
    int? version,
  }) {
    return NotificationPreferenceRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      notificationType: notificationType ?? this.notificationType,
      enabled: enabled ?? this.enabled,
      quietHoursStart: quietHoursStart is String?
          ? quietHoursStart
          : this.quietHoursStart,
      quietHoursEnd: quietHoursEnd is String?
          ? quietHoursEnd
          : this.quietHoursEnd,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class NotificationPreferenceRowUpdateTable
    extends _i1.UpdateTable<NotificationPreferenceRowTable> {
  NotificationPreferenceRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<String, String> notificationType(String value) =>
      _i1.ColumnValue(
        table.notificationType,
        value,
      );

  _i1.ColumnValue<bool, bool> enabled(bool value) => _i1.ColumnValue(
    table.enabled,
    value,
  );

  _i1.ColumnValue<String, String> quietHoursStart(String? value) =>
      _i1.ColumnValue(
        table.quietHoursStart,
        value,
      );

  _i1.ColumnValue<String, String> quietHoursEnd(String? value) =>
      _i1.ColumnValue(
        table.quietHoursEnd,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
    value,
  );
}

class NotificationPreferenceRowTable extends _i1.Table<int?> {
  NotificationPreferenceRowTable({super.tableRelation})
    : super(tableName: 'notification_preference') {
    updateTable = NotificationPreferenceRowUpdateTable(this);
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    notificationType = _i1.ColumnString(
      'notificationType',
      this,
    );
    enabled = _i1.ColumnBool(
      'enabled',
      this,
    );
    quietHoursStart = _i1.ColumnString(
      'quietHoursStart',
      this,
    );
    quietHoursEnd = _i1.ColumnString(
      'quietHoursEnd',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    version = _i1.ColumnInt(
      'version',
      this,
    );
  }

  late final NotificationPreferenceRowUpdateTable updateTable;

  late final _i1.ColumnInt profileId;

  late final _i1.ColumnString notificationType;

  late final _i1.ColumnBool enabled;

  late final _i1.ColumnString quietHoursStart;

  late final _i1.ColumnString quietHoursEnd;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    profileId,
    notificationType,
    enabled,
    quietHoursStart,
    quietHoursEnd,
    updatedAt,
    version,
  ];
}

class NotificationPreferenceRowInclude extends _i1.IncludeObject {
  NotificationPreferenceRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NotificationPreferenceRow.t;
}

class NotificationPreferenceRowIncludeList extends _i1.IncludeList {
  NotificationPreferenceRowIncludeList._({
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationPreferenceRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NotificationPreferenceRow.t;
}

class NotificationPreferenceRowRepository {
  const NotificationPreferenceRowRepository._();

  /// Returns a list of [NotificationPreferenceRow]s matching the given query parameters.
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
  Future<List<NotificationPreferenceRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<NotificationPreferenceRow>(
      where: where?.call(NotificationPreferenceRow.t),
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [NotificationPreferenceRow] matching the given query parameters.
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
  Future<NotificationPreferenceRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<NotificationPreferenceRow>(
      where: where?.call(NotificationPreferenceRow.t),
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [NotificationPreferenceRow] by its [id] or null if no such row exists.
  Future<NotificationPreferenceRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<NotificationPreferenceRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [NotificationPreferenceRow]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationPreferenceRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<NotificationPreferenceRow>> insert(
    _i1.Session session,
    List<NotificationPreferenceRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<NotificationPreferenceRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [NotificationPreferenceRow] and returns the inserted row.
  ///
  /// The returned [NotificationPreferenceRow] will have its `id` field set.
  Future<NotificationPreferenceRow> insertRow(
    _i1.Session session,
    NotificationPreferenceRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationPreferenceRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreferenceRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationPreferenceRow>> update(
    _i1.Session session,
    List<NotificationPreferenceRow> rows, {
    _i1.ColumnSelections<NotificationPreferenceRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationPreferenceRow>(
      rows,
      columns: columns?.call(NotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationPreferenceRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationPreferenceRow> updateRow(
    _i1.Session session,
    NotificationPreferenceRow row, {
    _i1.ColumnSelections<NotificationPreferenceRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationPreferenceRow>(
      row,
      columns: columns?.call(NotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationPreferenceRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationPreferenceRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NotificationPreferenceRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationPreferenceRow>(
      id,
      columnValues: columnValues(NotificationPreferenceRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreferenceRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationPreferenceRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NotificationPreferenceRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationPreferenceRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationPreferenceRow>(
      columnValues: columnValues(NotificationPreferenceRow.t.updateTable),
      where: where(NotificationPreferenceRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationPreferenceRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationPreferenceRow>> delete(
    _i1.Session session,
    List<NotificationPreferenceRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationPreferenceRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationPreferenceRow].
  Future<NotificationPreferenceRow> deleteRow(
    _i1.Session session,
    NotificationPreferenceRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationPreferenceRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationPreferenceRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NotificationPreferenceRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationPreferenceRow>(
      where: where(NotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationPreferenceRow>(
      where: where?.call(NotificationPreferenceRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
