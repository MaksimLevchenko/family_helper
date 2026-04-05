/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../lists/models/list_item_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_server/src/generated/protocol.dart' as _i4;

abstract class ListItemHistoryRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ListItemHistoryRow._({
    this.id,
    required this.itemId,
    this.item,
    required this.actorProfileId,
    this.actorProfile,
    required this.eventType,
    required this.createdAt,
  });

  factory ListItemHistoryRow({
    int? id,
    required int itemId,
    _i2.ListItemRow? item,
    required int actorProfileId,
    _i3.AppProfileRow? actorProfile,
    required String eventType,
    required DateTime createdAt,
  }) = _ListItemHistoryRowImpl;

  factory ListItemHistoryRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListItemHistoryRow(
      id: jsonSerialization['id'] as int?,
      itemId: jsonSerialization['itemId'] as int,
      item: jsonSerialization['item'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.ListItemRow>(
              jsonSerialization['item'],
            ),
      actorProfileId: jsonSerialization['actorProfileId'] as int,
      actorProfile: jsonSerialization['actorProfile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['actorProfile'],
            ),
      eventType: jsonSerialization['eventType'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ListItemHistoryRowTable();

  static const db = ListItemHistoryRowRepository._();

  @override
  int? id;

  int itemId;

  _i2.ListItemRow? item;

  int actorProfileId;

  _i3.AppProfileRow? actorProfile;

  String eventType;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ListItemHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ListItemHistoryRow copyWith({
    int? id,
    int? itemId,
    _i2.ListItemRow? item,
    int? actorProfileId,
    _i3.AppProfileRow? actorProfile,
    String? eventType,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ListItemHistoryRow',
      if (id != null) 'id': id,
      'itemId': itemId,
      if (item != null) 'item': item?.toJson(),
      'actorProfileId': actorProfileId,
      if (actorProfile != null) 'actorProfile': actorProfile?.toJson(),
      'eventType': eventType,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ListItemHistoryRow',
      if (id != null) 'id': id,
      'itemId': itemId,
      if (item != null) 'item': item?.toJsonForProtocol(),
      'actorProfileId': actorProfileId,
      if (actorProfile != null)
        'actorProfile': actorProfile?.toJsonForProtocol(),
      'eventType': eventType,
      'createdAt': createdAt.toJson(),
    };
  }

  static ListItemHistoryRowInclude include({
    _i2.ListItemRowInclude? item,
    _i3.AppProfileRowInclude? actorProfile,
  }) {
    return ListItemHistoryRowInclude._(
      item: item,
      actorProfile: actorProfile,
    );
  }

  static ListItemHistoryRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ListItemHistoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListItemHistoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListItemHistoryRowTable>? orderByList,
    ListItemHistoryRowInclude? include,
  }) {
    return ListItemHistoryRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ListItemHistoryRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ListItemHistoryRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListItemHistoryRowImpl extends ListItemHistoryRow {
  _ListItemHistoryRowImpl({
    int? id,
    required int itemId,
    _i2.ListItemRow? item,
    required int actorProfileId,
    _i3.AppProfileRow? actorProfile,
    required String eventType,
    required DateTime createdAt,
  }) : super._(
         id: id,
         itemId: itemId,
         item: item,
         actorProfileId: actorProfileId,
         actorProfile: actorProfile,
         eventType: eventType,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ListItemHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ListItemHistoryRow copyWith({
    Object? id = _Undefined,
    int? itemId,
    Object? item = _Undefined,
    int? actorProfileId,
    Object? actorProfile = _Undefined,
    String? eventType,
    DateTime? createdAt,
  }) {
    return ListItemHistoryRow(
      id: id is int? ? id : this.id,
      itemId: itemId ?? this.itemId,
      item: item is _i2.ListItemRow? ? item : this.item?.copyWith(),
      actorProfileId: actorProfileId ?? this.actorProfileId,
      actorProfile: actorProfile is _i3.AppProfileRow?
          ? actorProfile
          : this.actorProfile?.copyWith(),
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ListItemHistoryRowUpdateTable
    extends _i1.UpdateTable<ListItemHistoryRowTable> {
  ListItemHistoryRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> itemId(int value) => _i1.ColumnValue(
    table.itemId,
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

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ListItemHistoryRowTable extends _i1.Table<int?> {
  ListItemHistoryRowTable({super.tableRelation})
    : super(tableName: 'list_item_history') {
    updateTable = ListItemHistoryRowUpdateTable(this);
    itemId = _i1.ColumnInt(
      'itemId',
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
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ListItemHistoryRowUpdateTable updateTable;

  late final _i1.ColumnInt itemId;

  _i2.ListItemRowTable? _item;

  late final _i1.ColumnInt actorProfileId;

  _i3.AppProfileRowTable? _actorProfile;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnDateTime createdAt;

  _i2.ListItemRowTable get item {
    if (_item != null) return _item!;
    _item = _i1.createRelationTable(
      relationFieldName: 'item',
      field: ListItemHistoryRow.t.itemId,
      foreignField: _i2.ListItemRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ListItemRowTable(tableRelation: foreignTableRelation),
    );
    return _item!;
  }

  _i3.AppProfileRowTable get actorProfile {
    if (_actorProfile != null) return _actorProfile!;
    _actorProfile = _i1.createRelationTable(
      relationFieldName: 'actorProfile',
      field: ListItemHistoryRow.t.actorProfileId,
      foreignField: _i3.AppProfileRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AppProfileRowTable(tableRelation: foreignTableRelation),
    );
    return _actorProfile!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    itemId,
    actorProfileId,
    eventType,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'item') {
      return item;
    }
    if (relationField == 'actorProfile') {
      return actorProfile;
    }
    return null;
  }
}

class ListItemHistoryRowInclude extends _i1.IncludeObject {
  ListItemHistoryRowInclude._({
    _i2.ListItemRowInclude? item,
    _i3.AppProfileRowInclude? actorProfile,
  }) {
    _item = item;
    _actorProfile = actorProfile;
  }

  _i2.ListItemRowInclude? _item;

  _i3.AppProfileRowInclude? _actorProfile;

  @override
  Map<String, _i1.Include?> get includes => {
    'item': _item,
    'actorProfile': _actorProfile,
  };

  @override
  _i1.Table<int?> get table => ListItemHistoryRow.t;
}

class ListItemHistoryRowIncludeList extends _i1.IncludeList {
  ListItemHistoryRowIncludeList._({
    _i1.WhereExpressionBuilder<ListItemHistoryRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ListItemHistoryRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ListItemHistoryRow.t;
}

class ListItemHistoryRowRepository {
  const ListItemHistoryRowRepository._();

  final attachRow = const ListItemHistoryRowAttachRowRepository._();

  /// Returns a list of [ListItemHistoryRow]s matching the given query parameters.
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
  Future<List<ListItemHistoryRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListItemHistoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListItemHistoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListItemHistoryRowTable>? orderByList,
    _i1.Transaction? transaction,
    ListItemHistoryRowInclude? include,
  }) async {
    return session.db.find<ListItemHistoryRow>(
      where: where?.call(ListItemHistoryRow.t),
      orderBy: orderBy?.call(ListItemHistoryRow.t),
      orderByList: orderByList?.call(ListItemHistoryRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ListItemHistoryRow] matching the given query parameters.
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
  Future<ListItemHistoryRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListItemHistoryRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ListItemHistoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListItemHistoryRowTable>? orderByList,
    _i1.Transaction? transaction,
    ListItemHistoryRowInclude? include,
  }) async {
    return session.db.findFirstRow<ListItemHistoryRow>(
      where: where?.call(ListItemHistoryRow.t),
      orderBy: orderBy?.call(ListItemHistoryRow.t),
      orderByList: orderByList?.call(ListItemHistoryRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ListItemHistoryRow] by its [id] or null if no such row exists.
  Future<ListItemHistoryRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ListItemHistoryRowInclude? include,
  }) async {
    return session.db.findById<ListItemHistoryRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ListItemHistoryRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ListItemHistoryRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ListItemHistoryRow>> insert(
    _i1.Session session,
    List<ListItemHistoryRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ListItemHistoryRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ListItemHistoryRow] and returns the inserted row.
  ///
  /// The returned [ListItemHistoryRow] will have its `id` field set.
  Future<ListItemHistoryRow> insertRow(
    _i1.Session session,
    ListItemHistoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ListItemHistoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ListItemHistoryRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ListItemHistoryRow>> update(
    _i1.Session session,
    List<ListItemHistoryRow> rows, {
    _i1.ColumnSelections<ListItemHistoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ListItemHistoryRow>(
      rows,
      columns: columns?.call(ListItemHistoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ListItemHistoryRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ListItemHistoryRow> updateRow(
    _i1.Session session,
    ListItemHistoryRow row, {
    _i1.ColumnSelections<ListItemHistoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ListItemHistoryRow>(
      row,
      columns: columns?.call(ListItemHistoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ListItemHistoryRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ListItemHistoryRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ListItemHistoryRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ListItemHistoryRow>(
      id,
      columnValues: columnValues(ListItemHistoryRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ListItemHistoryRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ListItemHistoryRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ListItemHistoryRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ListItemHistoryRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListItemHistoryRowTable>? orderBy,
    _i1.OrderByListBuilder<ListItemHistoryRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ListItemHistoryRow>(
      columnValues: columnValues(ListItemHistoryRow.t.updateTable),
      where: where(ListItemHistoryRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ListItemHistoryRow.t),
      orderByList: orderByList?.call(ListItemHistoryRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ListItemHistoryRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ListItemHistoryRow>> delete(
    _i1.Session session,
    List<ListItemHistoryRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ListItemHistoryRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ListItemHistoryRow].
  Future<ListItemHistoryRow> deleteRow(
    _i1.Session session,
    ListItemHistoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ListItemHistoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ListItemHistoryRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ListItemHistoryRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ListItemHistoryRow>(
      where: where(ListItemHistoryRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListItemHistoryRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ListItemHistoryRow>(
      where: where?.call(ListItemHistoryRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ListItemHistoryRowAttachRowRepository {
  const ListItemHistoryRowAttachRowRepository._();

  /// Creates a relation between the given [ListItemHistoryRow] and [ListItemRow]
  /// by setting the [ListItemHistoryRow]'s foreign key `itemId` to refer to the [ListItemRow].
  Future<void> item(
    _i1.Session session,
    ListItemHistoryRow listItemHistoryRow,
    _i2.ListItemRow item, {
    _i1.Transaction? transaction,
  }) async {
    if (listItemHistoryRow.id == null) {
      throw ArgumentError.notNull('listItemHistoryRow.id');
    }
    if (item.id == null) {
      throw ArgumentError.notNull('item.id');
    }

    var $listItemHistoryRow = listItemHistoryRow.copyWith(itemId: item.id);
    await session.db.updateRow<ListItemHistoryRow>(
      $listItemHistoryRow,
      columns: [ListItemHistoryRow.t.itemId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ListItemHistoryRow] and [AppProfileRow]
  /// by setting the [ListItemHistoryRow]'s foreign key `actorProfileId` to refer to the [AppProfileRow].
  Future<void> actorProfile(
    _i1.Session session,
    ListItemHistoryRow listItemHistoryRow,
    _i3.AppProfileRow actorProfile, {
    _i1.Transaction? transaction,
  }) async {
    if (listItemHistoryRow.id == null) {
      throw ArgumentError.notNull('listItemHistoryRow.id');
    }
    if (actorProfile.id == null) {
      throw ArgumentError.notNull('actorProfile.id');
    }

    var $listItemHistoryRow = listItemHistoryRow.copyWith(
      actorProfileId: actorProfile.id,
    );
    await session.db.updateRow<ListItemHistoryRow>(
      $listItemHistoryRow,
      columns: [ListItemHistoryRow.t.actorProfileId],
      transaction: transaction,
    );
  }
}
