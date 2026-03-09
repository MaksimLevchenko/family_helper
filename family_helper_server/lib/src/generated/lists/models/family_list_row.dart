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

abstract class FamilyListRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FamilyListRow._({
    this.id,
    required this.familyId,
    required this.title,
    required this.listType,
    required this.createdByProfileId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory FamilyListRow({
    int? id,
    required int familyId,
    required String title,
    required String listType,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _FamilyListRowImpl;

  factory FamilyListRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyListRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      listType: jsonSerialization['listType'] as String,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
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

  static final t = FamilyListRowTable();

  static const db = FamilyListRowRepository._();

  @override
  int? id;

  int familyId;

  String title;

  String listType;

  int createdByProfileId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FamilyListRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyListRow copyWith({
    int? id,
    int? familyId,
    String? title,
    String? listType,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyListRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'title': title,
      'listType': listType,
      'createdByProfileId': createdByProfileId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyListRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'title': title,
      'listType': listType,
      'createdByProfileId': createdByProfileId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static FamilyListRowInclude include() {
    return FamilyListRowInclude._();
  }

  static FamilyListRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FamilyListRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyListRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyListRowTable>? orderByList,
    FamilyListRowInclude? include,
  }) {
    return FamilyListRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyListRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FamilyListRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyListRowImpl extends FamilyListRow {
  _FamilyListRowImpl({
    int? id,
    required int familyId,
    required String title,
    required String listType,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         listType: listType,
         createdByProfileId: createdByProfileId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyListRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyListRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? title,
    String? listType,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return FamilyListRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      listType: listType ?? this.listType,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class FamilyListRowUpdateTable extends _i1.UpdateTable<FamilyListRowTable> {
  FamilyListRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> listType(String value) => _i1.ColumnValue(
    table.listType,
    value,
  );

  _i1.ColumnValue<int, int> createdByProfileId(int value) => _i1.ColumnValue(
    table.createdByProfileId,
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

class FamilyListRowTable extends _i1.Table<int?> {
  FamilyListRowTable({super.tableRelation}) : super(tableName: 'family_list') {
    updateTable = FamilyListRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    listType = _i1.ColumnString(
      'listType',
      this,
    );
    createdByProfileId = _i1.ColumnInt(
      'createdByProfileId',
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

  late final FamilyListRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString listType;

  late final _i1.ColumnInt createdByProfileId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    title,
    listType,
    createdByProfileId,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class FamilyListRowInclude extends _i1.IncludeObject {
  FamilyListRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FamilyListRow.t;
}

class FamilyListRowIncludeList extends _i1.IncludeList {
  FamilyListRowIncludeList._({
    _i1.WhereExpressionBuilder<FamilyListRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FamilyListRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FamilyListRow.t;
}

class FamilyListRowRepository {
  const FamilyListRowRepository._();

  /// Returns a list of [FamilyListRow]s matching the given query parameters.
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
  Future<List<FamilyListRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyListRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyListRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyListRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FamilyListRow>(
      where: where?.call(FamilyListRow.t),
      orderBy: orderBy?.call(FamilyListRow.t),
      orderByList: orderByList?.call(FamilyListRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [FamilyListRow] matching the given query parameters.
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
  Future<FamilyListRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyListRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FamilyListRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyListRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FamilyListRow>(
      where: where?.call(FamilyListRow.t),
      orderBy: orderBy?.call(FamilyListRow.t),
      orderByList: orderByList?.call(FamilyListRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [FamilyListRow] by its [id] or null if no such row exists.
  Future<FamilyListRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FamilyListRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [FamilyListRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FamilyListRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FamilyListRow>> insert(
    _i1.Session session,
    List<FamilyListRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FamilyListRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FamilyListRow] and returns the inserted row.
  ///
  /// The returned [FamilyListRow] will have its `id` field set.
  Future<FamilyListRow> insertRow(
    _i1.Session session,
    FamilyListRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FamilyListRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FamilyListRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FamilyListRow>> update(
    _i1.Session session,
    List<FamilyListRow> rows, {
    _i1.ColumnSelections<FamilyListRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FamilyListRow>(
      rows,
      columns: columns?.call(FamilyListRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyListRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FamilyListRow> updateRow(
    _i1.Session session,
    FamilyListRow row, {
    _i1.ColumnSelections<FamilyListRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FamilyListRow>(
      row,
      columns: columns?.call(FamilyListRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyListRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FamilyListRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FamilyListRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FamilyListRow>(
      id,
      columnValues: columnValues(FamilyListRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FamilyListRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FamilyListRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FamilyListRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FamilyListRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyListRowTable>? orderBy,
    _i1.OrderByListBuilder<FamilyListRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FamilyListRow>(
      columnValues: columnValues(FamilyListRow.t.updateTable),
      where: where(FamilyListRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyListRow.t),
      orderByList: orderByList?.call(FamilyListRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FamilyListRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FamilyListRow>> delete(
    _i1.Session session,
    List<FamilyListRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FamilyListRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FamilyListRow].
  Future<FamilyListRow> deleteRow(
    _i1.Session session,
    FamilyListRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FamilyListRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FamilyListRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FamilyListRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FamilyListRow>(
      where: where(FamilyListRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyListRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FamilyListRow>(
      where: where?.call(FamilyListRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
