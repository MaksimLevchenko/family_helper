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

abstract class MediaObjectRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MediaObjectRow._({
    this.id,
    this.familyId,
    required this.uploadedByProfileId,
    required this.objectKey,
    required this.bucket,
    required this.mimeType,
    required this.sizeBytes,
    required this.status,
    this.thumbnailKey,
    this.clientOperationId,
    this.uploadExpiresAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory MediaObjectRow({
    int? id,
    int? familyId,
    required int uploadedByProfileId,
    required String objectKey,
    required String bucket,
    required String mimeType,
    required int sizeBytes,
    required String status,
    String? thumbnailKey,
    String? clientOperationId,
    DateTime? uploadExpiresAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _MediaObjectRowImpl;

  factory MediaObjectRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaObjectRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int?,
      uploadedByProfileId: jsonSerialization['uploadedByProfileId'] as int,
      objectKey: jsonSerialization['objectKey'] as String,
      bucket: jsonSerialization['bucket'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      status: jsonSerialization['status'] as String,
      thumbnailKey: jsonSerialization['thumbnailKey'] as String?,
      clientOperationId: jsonSerialization['clientOperationId'] as String?,
      uploadExpiresAt: jsonSerialization['uploadExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['uploadExpiresAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = MediaObjectRowTable();

  static const db = MediaObjectRowRepository._();

  @override
  int? id;

  int? familyId;

  int uploadedByProfileId;

  String objectKey;

  String bucket;

  String mimeType;

  int sizeBytes;

  String status;

  String? thumbnailKey;

  String? clientOperationId;

  DateTime? uploadExpiresAt;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MediaObjectRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaObjectRow copyWith({
    int? id,
    int? familyId,
    int? uploadedByProfileId,
    String? objectKey,
    String? bucket,
    String? mimeType,
    int? sizeBytes,
    String? status,
    String? thumbnailKey,
    String? clientOperationId,
    DateTime? uploadExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaObjectRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'uploadedByProfileId': uploadedByProfileId,
      'objectKey': objectKey,
      'bucket': bucket,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'status': status,
      if (thumbnailKey != null) 'thumbnailKey': thumbnailKey,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      if (uploadExpiresAt != null) 'uploadExpiresAt': uploadExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MediaObjectRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'uploadedByProfileId': uploadedByProfileId,
      'objectKey': objectKey,
      'bucket': bucket,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'status': status,
      if (thumbnailKey != null) 'thumbnailKey': thumbnailKey,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      if (uploadExpiresAt != null) 'uploadExpiresAt': uploadExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static MediaObjectRowInclude include() {
    return MediaObjectRowInclude._();
  }

  static MediaObjectRowIncludeList includeList({
    _i1.WhereExpressionBuilder<MediaObjectRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MediaObjectRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MediaObjectRowTable>? orderByList,
    MediaObjectRowInclude? include,
  }) {
    return MediaObjectRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MediaObjectRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MediaObjectRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaObjectRowImpl extends MediaObjectRow {
  _MediaObjectRowImpl({
    int? id,
    int? familyId,
    required int uploadedByProfileId,
    required String objectKey,
    required String bucket,
    required String mimeType,
    required int sizeBytes,
    required String status,
    String? thumbnailKey,
    String? clientOperationId,
    DateTime? uploadExpiresAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         uploadedByProfileId: uploadedByProfileId,
         objectKey: objectKey,
         bucket: bucket,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         status: status,
         thumbnailKey: thumbnailKey,
         clientOperationId: clientOperationId,
         uploadExpiresAt: uploadExpiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MediaObjectRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaObjectRow copyWith({
    Object? id = _Undefined,
    Object? familyId = _Undefined,
    int? uploadedByProfileId,
    String? objectKey,
    String? bucket,
    String? mimeType,
    int? sizeBytes,
    String? status,
    Object? thumbnailKey = _Undefined,
    Object? clientOperationId = _Undefined,
    Object? uploadExpiresAt = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MediaObjectRow(
      id: id is int? ? id : this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      uploadedByProfileId: uploadedByProfileId ?? this.uploadedByProfileId,
      objectKey: objectKey ?? this.objectKey,
      bucket: bucket ?? this.bucket,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      thumbnailKey: thumbnailKey is String? ? thumbnailKey : this.thumbnailKey,
      clientOperationId: clientOperationId is String?
          ? clientOperationId
          : this.clientOperationId,
      uploadExpiresAt: uploadExpiresAt is DateTime?
          ? uploadExpiresAt
          : this.uploadExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class MediaObjectRowUpdateTable extends _i1.UpdateTable<MediaObjectRowTable> {
  MediaObjectRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int? value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<int, int> uploadedByProfileId(int value) => _i1.ColumnValue(
    table.uploadedByProfileId,
    value,
  );

  _i1.ColumnValue<String, String> objectKey(String value) => _i1.ColumnValue(
    table.objectKey,
    value,
  );

  _i1.ColumnValue<String, String> bucket(String value) => _i1.ColumnValue(
    table.bucket,
    value,
  );

  _i1.ColumnValue<String, String> mimeType(String value) => _i1.ColumnValue(
    table.mimeType,
    value,
  );

  _i1.ColumnValue<int, int> sizeBytes(int value) => _i1.ColumnValue(
    table.sizeBytes,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> thumbnailKey(String? value) =>
      _i1.ColumnValue(
        table.thumbnailKey,
        value,
      );

  _i1.ColumnValue<String, String> clientOperationId(String? value) =>
      _i1.ColumnValue(
        table.clientOperationId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> uploadExpiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.uploadExpiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
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

class MediaObjectRowTable extends _i1.Table<int?> {
  MediaObjectRowTable({super.tableRelation})
    : super(tableName: 'media_object') {
    updateTable = MediaObjectRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    uploadedByProfileId = _i1.ColumnInt(
      'uploadedByProfileId',
      this,
    );
    objectKey = _i1.ColumnString(
      'objectKey',
      this,
    );
    bucket = _i1.ColumnString(
      'bucket',
      this,
    );
    mimeType = _i1.ColumnString(
      'mimeType',
      this,
    );
    sizeBytes = _i1.ColumnInt(
      'sizeBytes',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    thumbnailKey = _i1.ColumnString(
      'thumbnailKey',
      this,
    );
    clientOperationId = _i1.ColumnString(
      'clientOperationId',
      this,
    );
    uploadExpiresAt = _i1.ColumnDateTime(
      'uploadExpiresAt',
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

  late final MediaObjectRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  late final _i1.ColumnInt uploadedByProfileId;

  late final _i1.ColumnString objectKey;

  late final _i1.ColumnString bucket;

  late final _i1.ColumnString mimeType;

  late final _i1.ColumnInt sizeBytes;

  late final _i1.ColumnString status;

  late final _i1.ColumnString thumbnailKey;

  late final _i1.ColumnString clientOperationId;

  late final _i1.ColumnDateTime uploadExpiresAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    uploadedByProfileId,
    objectKey,
    bucket,
    mimeType,
    sizeBytes,
    status,
    thumbnailKey,
    clientOperationId,
    uploadExpiresAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
}

class MediaObjectRowInclude extends _i1.IncludeObject {
  MediaObjectRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MediaObjectRow.t;
}

class MediaObjectRowIncludeList extends _i1.IncludeList {
  MediaObjectRowIncludeList._({
    _i1.WhereExpressionBuilder<MediaObjectRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MediaObjectRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MediaObjectRow.t;
}

class MediaObjectRowRepository {
  const MediaObjectRowRepository._();

  /// Returns a list of [MediaObjectRow]s matching the given query parameters.
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
  Future<List<MediaObjectRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MediaObjectRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MediaObjectRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MediaObjectRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MediaObjectRow>(
      where: where?.call(MediaObjectRow.t),
      orderBy: orderBy?.call(MediaObjectRow.t),
      orderByList: orderByList?.call(MediaObjectRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MediaObjectRow] matching the given query parameters.
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
  Future<MediaObjectRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MediaObjectRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<MediaObjectRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MediaObjectRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MediaObjectRow>(
      where: where?.call(MediaObjectRow.t),
      orderBy: orderBy?.call(MediaObjectRow.t),
      orderByList: orderByList?.call(MediaObjectRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MediaObjectRow] by its [id] or null if no such row exists.
  Future<MediaObjectRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MediaObjectRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MediaObjectRow]s in the list and returns the inserted rows.
  ///
  /// The returned [MediaObjectRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MediaObjectRow>> insert(
    _i1.Session session,
    List<MediaObjectRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MediaObjectRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MediaObjectRow] and returns the inserted row.
  ///
  /// The returned [MediaObjectRow] will have its `id` field set.
  Future<MediaObjectRow> insertRow(
    _i1.Session session,
    MediaObjectRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MediaObjectRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MediaObjectRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MediaObjectRow>> update(
    _i1.Session session,
    List<MediaObjectRow> rows, {
    _i1.ColumnSelections<MediaObjectRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MediaObjectRow>(
      rows,
      columns: columns?.call(MediaObjectRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MediaObjectRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MediaObjectRow> updateRow(
    _i1.Session session,
    MediaObjectRow row, {
    _i1.ColumnSelections<MediaObjectRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MediaObjectRow>(
      row,
      columns: columns?.call(MediaObjectRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MediaObjectRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MediaObjectRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MediaObjectRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MediaObjectRow>(
      id,
      columnValues: columnValues(MediaObjectRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MediaObjectRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MediaObjectRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MediaObjectRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MediaObjectRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MediaObjectRowTable>? orderBy,
    _i1.OrderByListBuilder<MediaObjectRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MediaObjectRow>(
      columnValues: columnValues(MediaObjectRow.t.updateTable),
      where: where(MediaObjectRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MediaObjectRow.t),
      orderByList: orderByList?.call(MediaObjectRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MediaObjectRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MediaObjectRow>> delete(
    _i1.Session session,
    List<MediaObjectRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MediaObjectRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MediaObjectRow].
  Future<MediaObjectRow> deleteRow(
    _i1.Session session,
    MediaObjectRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MediaObjectRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MediaObjectRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MediaObjectRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MediaObjectRow>(
      where: where(MediaObjectRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MediaObjectRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MediaObjectRow>(
      where: where?.call(MediaObjectRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
