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

abstract class ListItemRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ListItemRow._({
    this.id,
    required this.listId,
    required this.title,
    required this.qty,
    this.unit,
    this.note,
    this.priceCents,
    this.category,
    required this.positionIndex,
    required this.isBought,
    this.boughtByProfileId,
    this.boughtAt,
    required this.createdByProfileId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory ListItemRow({
    int? id,
    required int listId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    required int positionIndex,
    required bool isBought,
    int? boughtByProfileId,
    DateTime? boughtAt,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _ListItemRowImpl;

  factory ListItemRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListItemRow(
      id: jsonSerialization['id'] as int?,
      listId: jsonSerialization['listId'] as int,
      title: jsonSerialization['title'] as String,
      qty: (jsonSerialization['qty'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String?,
      note: jsonSerialization['note'] as String?,
      priceCents: jsonSerialization['priceCents'] as int?,
      category: jsonSerialization['category'] as String?,
      positionIndex: jsonSerialization['positionIndex'] as int,
      isBought: jsonSerialization['isBought'] as bool,
      boughtByProfileId: jsonSerialization['boughtByProfileId'] as int?,
      boughtAt: jsonSerialization['boughtAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['boughtAt']),
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

  static final t = ListItemRowTable();

  static const db = ListItemRowRepository._();

  @override
  int? id;

  int listId;

  String title;

  double qty;

  String? unit;

  String? note;

  int? priceCents;

  String? category;

  int positionIndex;

  bool isBought;

  int? boughtByProfileId;

  DateTime? boughtAt;

  int createdByProfileId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ListItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ListItemRow copyWith({
    int? id,
    int? listId,
    String? title,
    double? qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    int? positionIndex,
    bool? isBought,
    int? boughtByProfileId,
    DateTime? boughtAt,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ListItemRow',
      if (id != null) 'id': id,
      'listId': listId,
      'title': title,
      'qty': qty,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (priceCents != null) 'priceCents': priceCents,
      if (category != null) 'category': category,
      'positionIndex': positionIndex,
      'isBought': isBought,
      if (boughtByProfileId != null) 'boughtByProfileId': boughtByProfileId,
      if (boughtAt != null) 'boughtAt': boughtAt?.toJson(),
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
      '__className__': 'ListItemRow',
      if (id != null) 'id': id,
      'listId': listId,
      'title': title,
      'qty': qty,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (priceCents != null) 'priceCents': priceCents,
      if (category != null) 'category': category,
      'positionIndex': positionIndex,
      'isBought': isBought,
      if (boughtByProfileId != null) 'boughtByProfileId': boughtByProfileId,
      if (boughtAt != null) 'boughtAt': boughtAt?.toJson(),
      'createdByProfileId': createdByProfileId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static ListItemRowInclude include() {
    return ListItemRowInclude._();
  }

  static ListItemRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ListItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListItemRowTable>? orderByList,
    ListItemRowInclude? include,
  }) {
    return ListItemRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ListItemRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ListItemRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListItemRowImpl extends ListItemRow {
  _ListItemRowImpl({
    int? id,
    required int listId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    required int positionIndex,
    required bool isBought,
    int? boughtByProfileId,
    DateTime? boughtAt,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         listId: listId,
         title: title,
         qty: qty,
         unit: unit,
         note: note,
         priceCents: priceCents,
         category: category,
         positionIndex: positionIndex,
         isBought: isBought,
         boughtByProfileId: boughtByProfileId,
         boughtAt: boughtAt,
         createdByProfileId: createdByProfileId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ListItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ListItemRow copyWith({
    Object? id = _Undefined,
    int? listId,
    String? title,
    double? qty,
    Object? unit = _Undefined,
    Object? note = _Undefined,
    Object? priceCents = _Undefined,
    Object? category = _Undefined,
    int? positionIndex,
    bool? isBought,
    Object? boughtByProfileId = _Undefined,
    Object? boughtAt = _Undefined,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return ListItemRow(
      id: id is int? ? id : this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      qty: qty ?? this.qty,
      unit: unit is String? ? unit : this.unit,
      note: note is String? ? note : this.note,
      priceCents: priceCents is int? ? priceCents : this.priceCents,
      category: category is String? ? category : this.category,
      positionIndex: positionIndex ?? this.positionIndex,
      isBought: isBought ?? this.isBought,
      boughtByProfileId: boughtByProfileId is int?
          ? boughtByProfileId
          : this.boughtByProfileId,
      boughtAt: boughtAt is DateTime? ? boughtAt : this.boughtAt,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class ListItemRowUpdateTable extends _i1.UpdateTable<ListItemRowTable> {
  ListItemRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> listId(int value) => _i1.ColumnValue(
    table.listId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<double, double> qty(double value) => _i1.ColumnValue(
    table.qty,
    value,
  );

  _i1.ColumnValue<String, String> unit(String? value) => _i1.ColumnValue(
    table.unit,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );

  _i1.ColumnValue<int, int> priceCents(int? value) => _i1.ColumnValue(
    table.priceCents,
    value,
  );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<int, int> positionIndex(int value) => _i1.ColumnValue(
    table.positionIndex,
    value,
  );

  _i1.ColumnValue<bool, bool> isBought(bool value) => _i1.ColumnValue(
    table.isBought,
    value,
  );

  _i1.ColumnValue<int, int> boughtByProfileId(int? value) => _i1.ColumnValue(
    table.boughtByProfileId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> boughtAt(DateTime? value) =>
      _i1.ColumnValue(
        table.boughtAt,
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

class ListItemRowTable extends _i1.Table<int?> {
  ListItemRowTable({super.tableRelation}) : super(tableName: 'list_item') {
    updateTable = ListItemRowUpdateTable(this);
    listId = _i1.ColumnInt(
      'listId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    qty = _i1.ColumnDouble(
      'qty',
      this,
    );
    unit = _i1.ColumnString(
      'unit',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
    priceCents = _i1.ColumnInt(
      'priceCents',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    positionIndex = _i1.ColumnInt(
      'positionIndex',
      this,
    );
    isBought = _i1.ColumnBool(
      'isBought',
      this,
    );
    boughtByProfileId = _i1.ColumnInt(
      'boughtByProfileId',
      this,
    );
    boughtAt = _i1.ColumnDateTime(
      'boughtAt',
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

  late final ListItemRowUpdateTable updateTable;

  late final _i1.ColumnInt listId;

  late final _i1.ColumnString title;

  late final _i1.ColumnDouble qty;

  late final _i1.ColumnString unit;

  late final _i1.ColumnString note;

  late final _i1.ColumnInt priceCents;

  late final _i1.ColumnString category;

  late final _i1.ColumnInt positionIndex;

  late final _i1.ColumnBool isBought;

  late final _i1.ColumnInt boughtByProfileId;

  late final _i1.ColumnDateTime boughtAt;

  late final _i1.ColumnInt createdByProfileId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    listId,
    title,
    qty,
    unit,
    note,
    priceCents,
    category,
    positionIndex,
    isBought,
    boughtByProfileId,
    boughtAt,
    createdByProfileId,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class ListItemRowInclude extends _i1.IncludeObject {
  ListItemRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ListItemRow.t;
}

class ListItemRowIncludeList extends _i1.IncludeList {
  ListItemRowIncludeList._({
    _i1.WhereExpressionBuilder<ListItemRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ListItemRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ListItemRow.t;
}

class ListItemRowRepository {
  const ListItemRowRepository._();

  /// Returns a list of [ListItemRow]s matching the given query parameters.
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
  Future<List<ListItemRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListItemRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ListItemRow>(
      where: where?.call(ListItemRow.t),
      orderBy: orderBy?.call(ListItemRow.t),
      orderByList: orderByList?.call(ListItemRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ListItemRow] matching the given query parameters.
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
  Future<ListItemRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListItemRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ListItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListItemRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ListItemRow>(
      where: where?.call(ListItemRow.t),
      orderBy: orderBy?.call(ListItemRow.t),
      orderByList: orderByList?.call(ListItemRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ListItemRow] by its [id] or null if no such row exists.
  Future<ListItemRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ListItemRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ListItemRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ListItemRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ListItemRow>> insert(
    _i1.Session session,
    List<ListItemRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ListItemRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ListItemRow] and returns the inserted row.
  ///
  /// The returned [ListItemRow] will have its `id` field set.
  Future<ListItemRow> insertRow(
    _i1.Session session,
    ListItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ListItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ListItemRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ListItemRow>> update(
    _i1.Session session,
    List<ListItemRow> rows, {
    _i1.ColumnSelections<ListItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ListItemRow>(
      rows,
      columns: columns?.call(ListItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ListItemRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ListItemRow> updateRow(
    _i1.Session session,
    ListItemRow row, {
    _i1.ColumnSelections<ListItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ListItemRow>(
      row,
      columns: columns?.call(ListItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ListItemRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ListItemRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ListItemRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ListItemRow>(
      id,
      columnValues: columnValues(ListItemRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ListItemRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ListItemRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ListItemRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ListItemRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListItemRowTable>? orderBy,
    _i1.OrderByListBuilder<ListItemRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ListItemRow>(
      columnValues: columnValues(ListItemRow.t.updateTable),
      where: where(ListItemRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ListItemRow.t),
      orderByList: orderByList?.call(ListItemRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ListItemRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ListItemRow>> delete(
    _i1.Session session,
    List<ListItemRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ListItemRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ListItemRow].
  Future<ListItemRow> deleteRow(
    _i1.Session session,
    ListItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ListItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ListItemRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ListItemRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ListItemRow>(
      where: where(ListItemRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListItemRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ListItemRow>(
      where: where?.call(ListItemRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
