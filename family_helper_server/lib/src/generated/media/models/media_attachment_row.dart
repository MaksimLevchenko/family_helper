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

abstract class MediaAttachmentRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MediaAttachmentRow._({
    this.id,
    required this.mediaId,
    required this.entityType,
    required this.entityId,
    required this.createdByProfileId,
    required this.createdAt,
    this.deletedAt,
    required this.version,
  });

  factory MediaAttachmentRow({
    int? id,
    required int mediaId,
    required String entityType,
    required int entityId,
    required int createdByProfileId,
    required DateTime createdAt,
    DateTime? deletedAt,
    required int version,
  }) = _MediaAttachmentRowImpl;

  factory MediaAttachmentRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaAttachmentRow(
      id: jsonSerialization['id'] as int?,
      mediaId: jsonSerialization['mediaId'] as int,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = MediaAttachmentRowTable();

  static const db = MediaAttachmentRowRepository._();

  @override
  int? id;

  int mediaId;

  String entityType;

  int entityId;

  int createdByProfileId;

  DateTime createdAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MediaAttachmentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaAttachmentRow copyWith({
    int? id,
    int? mediaId,
    String? entityType,
    int? entityId,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaAttachmentRow',
      if (id != null) 'id': id,
      'mediaId': mediaId,
      'entityType': entityType,
      'entityId': entityId,
      'createdByProfileId': createdByProfileId,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MediaAttachmentRow',
      if (id != null) 'id': id,
      'mediaId': mediaId,
      'entityType': entityType,
      'entityId': entityId,
      'createdByProfileId': createdByProfileId,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static MediaAttachmentRowInclude include() {
    return MediaAttachmentRowInclude._();
  }

  static MediaAttachmentRowIncludeList includeList({
    _i1.WhereExpressionBuilder<MediaAttachmentRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MediaAttachmentRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MediaAttachmentRowTable>? orderByList,
    MediaAttachmentRowInclude? include,
  }) {
    return MediaAttachmentRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MediaAttachmentRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MediaAttachmentRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaAttachmentRowImpl extends MediaAttachmentRow {
  _MediaAttachmentRowImpl({
    int? id,
    required int mediaId,
    required String entityType,
    required int entityId,
    required int createdByProfileId,
    required DateTime createdAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         mediaId: mediaId,
         entityType: entityType,
         entityId: entityId,
         createdByProfileId: createdByProfileId,
         createdAt: createdAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MediaAttachmentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaAttachmentRow copyWith({
    Object? id = _Undefined,
    int? mediaId,
    String? entityType,
    int? entityId,
    int? createdByProfileId,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MediaAttachmentRow(
      id: id is int? ? id : this.id,
      mediaId: mediaId ?? this.mediaId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class MediaAttachmentRowUpdateTable
    extends _i1.UpdateTable<MediaAttachmentRowTable> {
  MediaAttachmentRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> mediaId(int value) => _i1.ColumnValue(
    table.mediaId,
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

  _i1.ColumnValue<int, int> createdByProfileId(int value) => _i1.ColumnValue(
    table.createdByProfileId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
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

class MediaAttachmentRowTable extends _i1.Table<int?> {
  MediaAttachmentRowTable({super.tableRelation})
    : super(tableName: 'media_attachment') {
    updateTable = MediaAttachmentRowUpdateTable(this);
    mediaId = _i1.ColumnInt(
      'mediaId',
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
    createdByProfileId = _i1.ColumnInt(
      'createdByProfileId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
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

  late final MediaAttachmentRowUpdateTable updateTable;

  late final _i1.ColumnInt mediaId;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnInt entityId;

  late final _i1.ColumnInt createdByProfileId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    mediaId,
    entityType,
    entityId,
    createdByProfileId,
    createdAt,
    deletedAt,
    version,
  ];
}

class MediaAttachmentRowInclude extends _i1.IncludeObject {
  MediaAttachmentRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MediaAttachmentRow.t;
}

class MediaAttachmentRowIncludeList extends _i1.IncludeList {
  MediaAttachmentRowIncludeList._({
    _i1.WhereExpressionBuilder<MediaAttachmentRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MediaAttachmentRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MediaAttachmentRow.t;
}

class MediaAttachmentRowRepository {
  const MediaAttachmentRowRepository._();

  /// Returns a list of [MediaAttachmentRow]s matching the given query parameters.
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
  Future<List<MediaAttachmentRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MediaAttachmentRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MediaAttachmentRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MediaAttachmentRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MediaAttachmentRow>(
      where: where?.call(MediaAttachmentRow.t),
      orderBy: orderBy?.call(MediaAttachmentRow.t),
      orderByList: orderByList?.call(MediaAttachmentRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MediaAttachmentRow] matching the given query parameters.
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
  Future<MediaAttachmentRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MediaAttachmentRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<MediaAttachmentRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MediaAttachmentRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MediaAttachmentRow>(
      where: where?.call(MediaAttachmentRow.t),
      orderBy: orderBy?.call(MediaAttachmentRow.t),
      orderByList: orderByList?.call(MediaAttachmentRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MediaAttachmentRow] by its [id] or null if no such row exists.
  Future<MediaAttachmentRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MediaAttachmentRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MediaAttachmentRow]s in the list and returns the inserted rows.
  ///
  /// The returned [MediaAttachmentRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MediaAttachmentRow>> insert(
    _i1.Session session,
    List<MediaAttachmentRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MediaAttachmentRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MediaAttachmentRow] and returns the inserted row.
  ///
  /// The returned [MediaAttachmentRow] will have its `id` field set.
  Future<MediaAttachmentRow> insertRow(
    _i1.Session session,
    MediaAttachmentRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MediaAttachmentRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MediaAttachmentRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MediaAttachmentRow>> update(
    _i1.Session session,
    List<MediaAttachmentRow> rows, {
    _i1.ColumnSelections<MediaAttachmentRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MediaAttachmentRow>(
      rows,
      columns: columns?.call(MediaAttachmentRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MediaAttachmentRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MediaAttachmentRow> updateRow(
    _i1.Session session,
    MediaAttachmentRow row, {
    _i1.ColumnSelections<MediaAttachmentRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MediaAttachmentRow>(
      row,
      columns: columns?.call(MediaAttachmentRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MediaAttachmentRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MediaAttachmentRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MediaAttachmentRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MediaAttachmentRow>(
      id,
      columnValues: columnValues(MediaAttachmentRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MediaAttachmentRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MediaAttachmentRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MediaAttachmentRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<MediaAttachmentRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MediaAttachmentRowTable>? orderBy,
    _i1.OrderByListBuilder<MediaAttachmentRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MediaAttachmentRow>(
      columnValues: columnValues(MediaAttachmentRow.t.updateTable),
      where: where(MediaAttachmentRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MediaAttachmentRow.t),
      orderByList: orderByList?.call(MediaAttachmentRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MediaAttachmentRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MediaAttachmentRow>> delete(
    _i1.Session session,
    List<MediaAttachmentRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MediaAttachmentRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MediaAttachmentRow].
  Future<MediaAttachmentRow> deleteRow(
    _i1.Session session,
    MediaAttachmentRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MediaAttachmentRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MediaAttachmentRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MediaAttachmentRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MediaAttachmentRow>(
      where: where(MediaAttachmentRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MediaAttachmentRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MediaAttachmentRow>(
      where: where?.call(MediaAttachmentRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
