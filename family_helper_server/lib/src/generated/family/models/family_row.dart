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

abstract class FamilyRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FamilyRow._({
    this.id,
    required this.title,
    required this.ownerProfileId,
    required this.memberLimit,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory FamilyRow({
    int? id,
    required String title,
    required int ownerProfileId,
    required int memberLimit,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _FamilyRowImpl;

  factory FamilyRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyRow(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      ownerProfileId: jsonSerialization['ownerProfileId'] as int,
      memberLimit: jsonSerialization['memberLimit'] as int,
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

  static final t = FamilyRowTable();

  static const db = FamilyRowRepository._();

  @override
  int? id;

  String title;

  int ownerProfileId;

  int memberLimit;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FamilyRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyRow copyWith({
    int? id,
    String? title,
    int? ownerProfileId,
    int? memberLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyRow',
      if (id != null) 'id': id,
      'title': title,
      'ownerProfileId': ownerProfileId,
      'memberLimit': memberLimit,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyRow',
      if (id != null) 'id': id,
      'title': title,
      'ownerProfileId': ownerProfileId,
      'memberLimit': memberLimit,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static FamilyRowInclude include() {
    return FamilyRowInclude._();
  }

  static FamilyRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FamilyRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyRowTable>? orderByList,
    FamilyRowInclude? include,
  }) {
    return FamilyRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FamilyRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyRowImpl extends FamilyRow {
  _FamilyRowImpl({
    int? id,
    required String title,
    required int ownerProfileId,
    required int memberLimit,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         title: title,
         ownerProfileId: ownerProfileId,
         memberLimit: memberLimit,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyRow copyWith({
    Object? id = _Undefined,
    String? title,
    int? ownerProfileId,
    int? memberLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return FamilyRow(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      ownerProfileId: ownerProfileId ?? this.ownerProfileId,
      memberLimit: memberLimit ?? this.memberLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class FamilyRowUpdateTable extends _i1.UpdateTable<FamilyRowTable> {
  FamilyRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<int, int> ownerProfileId(int value) => _i1.ColumnValue(
    table.ownerProfileId,
    value,
  );

  _i1.ColumnValue<int, int> memberLimit(int value) => _i1.ColumnValue(
    table.memberLimit,
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

class FamilyRowTable extends _i1.Table<int?> {
  FamilyRowTable({super.tableRelation}) : super(tableName: 'family') {
    updateTable = FamilyRowUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    ownerProfileId = _i1.ColumnInt(
      'ownerProfileId',
      this,
    );
    memberLimit = _i1.ColumnInt(
      'memberLimit',
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

  late final FamilyRowUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnInt ownerProfileId;

  late final _i1.ColumnInt memberLimit;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    ownerProfileId,
    memberLimit,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class FamilyRowInclude extends _i1.IncludeObject {
  FamilyRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FamilyRow.t;
}

class FamilyRowIncludeList extends _i1.IncludeList {
  FamilyRowIncludeList._({
    _i1.WhereExpressionBuilder<FamilyRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FamilyRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FamilyRow.t;
}

class FamilyRowRepository {
  const FamilyRowRepository._();

  /// Returns a list of [FamilyRow]s matching the given query parameters.
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
  Future<List<FamilyRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FamilyRow>(
      where: where?.call(FamilyRow.t),
      orderBy: orderBy?.call(FamilyRow.t),
      orderByList: orderByList?.call(FamilyRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [FamilyRow] matching the given query parameters.
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
  Future<FamilyRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FamilyRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FamilyRow>(
      where: where?.call(FamilyRow.t),
      orderBy: orderBy?.call(FamilyRow.t),
      orderByList: orderByList?.call(FamilyRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [FamilyRow] by its [id] or null if no such row exists.
  Future<FamilyRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FamilyRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [FamilyRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FamilyRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FamilyRow>> insert(
    _i1.Session session,
    List<FamilyRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FamilyRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FamilyRow] and returns the inserted row.
  ///
  /// The returned [FamilyRow] will have its `id` field set.
  Future<FamilyRow> insertRow(
    _i1.Session session,
    FamilyRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FamilyRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FamilyRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FamilyRow>> update(
    _i1.Session session,
    List<FamilyRow> rows, {
    _i1.ColumnSelections<FamilyRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FamilyRow>(
      rows,
      columns: columns?.call(FamilyRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FamilyRow> updateRow(
    _i1.Session session,
    FamilyRow row, {
    _i1.ColumnSelections<FamilyRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FamilyRow>(
      row,
      columns: columns?.call(FamilyRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FamilyRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FamilyRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FamilyRow>(
      id,
      columnValues: columnValues(FamilyRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FamilyRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FamilyRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FamilyRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FamilyRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyRowTable>? orderBy,
    _i1.OrderByListBuilder<FamilyRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FamilyRow>(
      columnValues: columnValues(FamilyRow.t.updateTable),
      where: where(FamilyRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyRow.t),
      orderByList: orderByList?.call(FamilyRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FamilyRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FamilyRow>> delete(
    _i1.Session session,
    List<FamilyRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FamilyRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FamilyRow].
  Future<FamilyRow> deleteRow(
    _i1.Session session,
    FamilyRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FamilyRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FamilyRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FamilyRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FamilyRow>(
      where: where(FamilyRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FamilyRow>(
      where: where?.call(FamilyRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
