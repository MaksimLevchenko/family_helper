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

abstract class MoneyContributionRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MoneyContributionRow._({
    this.id,
    required this.goalId,
    required this.profileId,
    required this.amountCents,
    required this.currency,
    this.note,
    this.clientOperationId,
    required this.createdAt,
    this.revokedAt,
  });

  factory MoneyContributionRow({
    int? id,
    required int goalId,
    required int profileId,
    required int amountCents,
    required String currency,
    String? note,
    String? clientOperationId,
    required DateTime createdAt,
    DateTime? revokedAt,
  }) = _MoneyContributionRowImpl;

  factory MoneyContributionRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MoneyContributionRow(
      id: jsonSerialization['id'] as int?,
      goalId: jsonSerialization['goalId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      note: jsonSerialization['note'] as String?,
      clientOperationId: jsonSerialization['clientOperationId'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  static final t = MoneyContributionRowTable();

  static const db = MoneyContributionRowRepository._();

  @override
  int? id;

  int goalId;

  int profileId;

  int amountCents;

  String currency;

  String? note;

  String? clientOperationId;

  DateTime createdAt;

  DateTime? revokedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MoneyContributionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyContributionRow copyWith({
    int? id,
    int? goalId,
    int? profileId,
    int? amountCents,
    String? currency,
    String? note,
    String? clientOperationId,
    DateTime? createdAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyContributionRow',
      if (id != null) 'id': id,
      'goalId': goalId,
      'profileId': profileId,
      'amountCents': amountCents,
      'currency': currency,
      if (note != null) 'note': note,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MoneyContributionRow',
      if (id != null) 'id': id,
      'goalId': goalId,
      'profileId': profileId,
      'amountCents': amountCents,
      'currency': currency,
      if (note != null) 'note': note,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  static MoneyContributionRowInclude include() {
    return MoneyContributionRowInclude._();
  }

  static MoneyContributionRowIncludeList includeList({
    _i1.WhereExpressionBuilder<MoneyContributionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MoneyContributionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MoneyContributionRowTable>? orderByList,
    MoneyContributionRowInclude? include,
  }) {
    return MoneyContributionRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MoneyContributionRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MoneyContributionRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MoneyContributionRowImpl extends MoneyContributionRow {
  _MoneyContributionRowImpl({
    int? id,
    required int goalId,
    required int profileId,
    required int amountCents,
    required String currency,
    String? note,
    String? clientOperationId,
    required DateTime createdAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         goalId: goalId,
         profileId: profileId,
         amountCents: amountCents,
         currency: currency,
         note: note,
         clientOperationId: clientOperationId,
         createdAt: createdAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [MoneyContributionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyContributionRow copyWith({
    Object? id = _Undefined,
    int? goalId,
    int? profileId,
    int? amountCents,
    String? currency,
    Object? note = _Undefined,
    Object? clientOperationId = _Undefined,
    DateTime? createdAt,
    Object? revokedAt = _Undefined,
  }) {
    return MoneyContributionRow(
      id: id is int? ? id : this.id,
      goalId: goalId ?? this.goalId,
      profileId: profileId ?? this.profileId,
      amountCents: amountCents ?? this.amountCents,
      currency: currency ?? this.currency,
      note: note is String? ? note : this.note,
      clientOperationId: clientOperationId is String?
          ? clientOperationId
          : this.clientOperationId,
      createdAt: createdAt ?? this.createdAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}

class MoneyContributionRowUpdateTable
    extends _i1.UpdateTable<MoneyContributionRowTable> {
  MoneyContributionRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> goalId(int value) => _i1.ColumnValue(
    table.goalId,
    value,
  );

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<int, int> amountCents(int value) => _i1.ColumnValue(
    table.amountCents,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );

  _i1.ColumnValue<String, String> clientOperationId(String? value) =>
      _i1.ColumnValue(
        table.clientOperationId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> revokedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.revokedAt,
        value,
      );
}

class MoneyContributionRowTable extends _i1.Table<int?> {
  MoneyContributionRowTable({super.tableRelation})
    : super(tableName: 'money_contribution') {
    updateTable = MoneyContributionRowUpdateTable(this);
    goalId = _i1.ColumnInt(
      'goalId',
      this,
    );
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    amountCents = _i1.ColumnInt(
      'amountCents',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
    clientOperationId = _i1.ColumnString(
      'clientOperationId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    revokedAt = _i1.ColumnDateTime(
      'revokedAt',
      this,
    );
  }

  late final MoneyContributionRowUpdateTable updateTable;

  late final _i1.ColumnInt goalId;

  late final _i1.ColumnInt profileId;

  late final _i1.ColumnInt amountCents;

  late final _i1.ColumnString currency;

  late final _i1.ColumnString note;

  late final _i1.ColumnString clientOperationId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime revokedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    goalId,
    profileId,
    amountCents,
    currency,
    note,
    clientOperationId,
    createdAt,
    revokedAt,
  ];
}

class MoneyContributionRowInclude extends _i1.IncludeObject {
  MoneyContributionRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MoneyContributionRow.t;
}

class MoneyContributionRowIncludeList extends _i1.IncludeList {
  MoneyContributionRowIncludeList._({
    _i1.WhereExpressionBuilder<MoneyContributionRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MoneyContributionRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MoneyContributionRow.t;
}

class MoneyContributionRowRepository {
  const MoneyContributionRowRepository._();

  /// Returns a list of [MoneyContributionRow]s matching the given query parameters.
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
  Future<List<MoneyContributionRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MoneyContributionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MoneyContributionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MoneyContributionRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MoneyContributionRow>(
      where: where?.call(MoneyContributionRow.t),
      orderBy: orderBy?.call(MoneyContributionRow.t),
      orderByList: orderByList?.call(MoneyContributionRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MoneyContributionRow] matching the given query parameters.
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
  Future<MoneyContributionRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MoneyContributionRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<MoneyContributionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MoneyContributionRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MoneyContributionRow>(
      where: where?.call(MoneyContributionRow.t),
      orderBy: orderBy?.call(MoneyContributionRow.t),
      orderByList: orderByList?.call(MoneyContributionRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MoneyContributionRow] by its [id] or null if no such row exists.
  Future<MoneyContributionRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MoneyContributionRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MoneyContributionRow]s in the list and returns the inserted rows.
  ///
  /// The returned [MoneyContributionRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MoneyContributionRow>> insert(
    _i1.Session session,
    List<MoneyContributionRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MoneyContributionRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MoneyContributionRow] and returns the inserted row.
  ///
  /// The returned [MoneyContributionRow] will have its `id` field set.
  Future<MoneyContributionRow> insertRow(
    _i1.Session session,
    MoneyContributionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MoneyContributionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MoneyContributionRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MoneyContributionRow>> update(
    _i1.Session session,
    List<MoneyContributionRow> rows, {
    _i1.ColumnSelections<MoneyContributionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MoneyContributionRow>(
      rows,
      columns: columns?.call(MoneyContributionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MoneyContributionRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MoneyContributionRow> updateRow(
    _i1.Session session,
    MoneyContributionRow row, {
    _i1.ColumnSelections<MoneyContributionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MoneyContributionRow>(
      row,
      columns: columns?.call(MoneyContributionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MoneyContributionRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MoneyContributionRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MoneyContributionRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MoneyContributionRow>(
      id,
      columnValues: columnValues(MoneyContributionRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MoneyContributionRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MoneyContributionRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MoneyContributionRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<MoneyContributionRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MoneyContributionRowTable>? orderBy,
    _i1.OrderByListBuilder<MoneyContributionRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MoneyContributionRow>(
      columnValues: columnValues(MoneyContributionRow.t.updateTable),
      where: where(MoneyContributionRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MoneyContributionRow.t),
      orderByList: orderByList?.call(MoneyContributionRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MoneyContributionRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MoneyContributionRow>> delete(
    _i1.Session session,
    List<MoneyContributionRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MoneyContributionRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MoneyContributionRow].
  Future<MoneyContributionRow> deleteRow(
    _i1.Session session,
    MoneyContributionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MoneyContributionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MoneyContributionRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MoneyContributionRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MoneyContributionRow>(
      where: where(MoneyContributionRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MoneyContributionRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MoneyContributionRow>(
      where: where?.call(MoneyContributionRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
