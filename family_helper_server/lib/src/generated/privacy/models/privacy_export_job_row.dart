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

abstract class PrivacyExportJobRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PrivacyExportJobRow._({
    this.id,
    required this.profileId,
    required this.status,
    required this.objectKey,
    this.signedUrl,
    this.expiresAt,
    required this.createdAt,
    this.completedAt,
  });

  factory PrivacyExportJobRow({
    int? id,
    required int profileId,
    required String status,
    required String objectKey,
    String? signedUrl,
    DateTime? expiresAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _PrivacyExportJobRowImpl;

  factory PrivacyExportJobRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PrivacyExportJobRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      status: jsonSerialization['status'] as String,
      objectKey: jsonSerialization['objectKey'] as String,
      signedUrl: jsonSerialization['signedUrl'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  static final t = PrivacyExportJobRowTable();

  static const db = PrivacyExportJobRowRepository._();

  @override
  int? id;

  int profileId;

  String status;

  String objectKey;

  String? signedUrl;

  DateTime? expiresAt;

  DateTime createdAt;

  DateTime? completedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PrivacyExportJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PrivacyExportJobRow copyWith({
    int? id,
    int? profileId,
    String? status,
    String? objectKey,
    String? signedUrl,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PrivacyExportJobRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'status': status,
      'objectKey': objectKey,
      if (signedUrl != null) 'signedUrl': signedUrl,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PrivacyExportJobRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'status': status,
      'objectKey': objectKey,
      if (signedUrl != null) 'signedUrl': signedUrl,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static PrivacyExportJobRowInclude include() {
    return PrivacyExportJobRowInclude._();
  }

  static PrivacyExportJobRowIncludeList includeList({
    _i1.WhereExpressionBuilder<PrivacyExportJobRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PrivacyExportJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PrivacyExportJobRowTable>? orderByList,
    PrivacyExportJobRowInclude? include,
  }) {
    return PrivacyExportJobRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PrivacyExportJobRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PrivacyExportJobRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PrivacyExportJobRowImpl extends PrivacyExportJobRow {
  _PrivacyExportJobRowImpl({
    int? id,
    required int profileId,
    required String status,
    required String objectKey,
    String? signedUrl,
    DateTime? expiresAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         profileId: profileId,
         status: status,
         objectKey: objectKey,
         signedUrl: signedUrl,
         expiresAt: expiresAt,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [PrivacyExportJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PrivacyExportJobRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? status,
    String? objectKey,
    Object? signedUrl = _Undefined,
    Object? expiresAt = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return PrivacyExportJobRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      status: status ?? this.status,
      objectKey: objectKey ?? this.objectKey,
      signedUrl: signedUrl is String? ? signedUrl : this.signedUrl,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class PrivacyExportJobRowUpdateTable
    extends _i1.UpdateTable<PrivacyExportJobRowTable> {
  PrivacyExportJobRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> objectKey(String value) => _i1.ColumnValue(
    table.objectKey,
    value,
  );

  _i1.ColumnValue<String, String> signedUrl(String? value) => _i1.ColumnValue(
    table.signedUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.completedAt,
        value,
      );
}

class PrivacyExportJobRowTable extends _i1.Table<int?> {
  PrivacyExportJobRowTable({super.tableRelation})
    : super(tableName: 'privacy_export_job') {
    updateTable = PrivacyExportJobRowUpdateTable(this);
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    objectKey = _i1.ColumnString(
      'objectKey',
      this,
    );
    signedUrl = _i1.ColumnString(
      'signedUrl',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  late final PrivacyExportJobRowUpdateTable updateTable;

  late final _i1.ColumnInt profileId;

  late final _i1.ColumnString status;

  late final _i1.ColumnString objectKey;

  late final _i1.ColumnString signedUrl;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime completedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    profileId,
    status,
    objectKey,
    signedUrl,
    expiresAt,
    createdAt,
    completedAt,
  ];
}

class PrivacyExportJobRowInclude extends _i1.IncludeObject {
  PrivacyExportJobRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PrivacyExportJobRow.t;
}

class PrivacyExportJobRowIncludeList extends _i1.IncludeList {
  PrivacyExportJobRowIncludeList._({
    _i1.WhereExpressionBuilder<PrivacyExportJobRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PrivacyExportJobRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PrivacyExportJobRow.t;
}

class PrivacyExportJobRowRepository {
  const PrivacyExportJobRowRepository._();

  /// Returns a list of [PrivacyExportJobRow]s matching the given query parameters.
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
  Future<List<PrivacyExportJobRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PrivacyExportJobRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PrivacyExportJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PrivacyExportJobRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PrivacyExportJobRow>(
      where: where?.call(PrivacyExportJobRow.t),
      orderBy: orderBy?.call(PrivacyExportJobRow.t),
      orderByList: orderByList?.call(PrivacyExportJobRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PrivacyExportJobRow] matching the given query parameters.
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
  Future<PrivacyExportJobRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PrivacyExportJobRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<PrivacyExportJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PrivacyExportJobRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PrivacyExportJobRow>(
      where: where?.call(PrivacyExportJobRow.t),
      orderBy: orderBy?.call(PrivacyExportJobRow.t),
      orderByList: orderByList?.call(PrivacyExportJobRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PrivacyExportJobRow] by its [id] or null if no such row exists.
  Future<PrivacyExportJobRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PrivacyExportJobRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PrivacyExportJobRow]s in the list and returns the inserted rows.
  ///
  /// The returned [PrivacyExportJobRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PrivacyExportJobRow>> insert(
    _i1.Session session,
    List<PrivacyExportJobRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PrivacyExportJobRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PrivacyExportJobRow] and returns the inserted row.
  ///
  /// The returned [PrivacyExportJobRow] will have its `id` field set.
  Future<PrivacyExportJobRow> insertRow(
    _i1.Session session,
    PrivacyExportJobRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PrivacyExportJobRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PrivacyExportJobRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PrivacyExportJobRow>> update(
    _i1.Session session,
    List<PrivacyExportJobRow> rows, {
    _i1.ColumnSelections<PrivacyExportJobRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PrivacyExportJobRow>(
      rows,
      columns: columns?.call(PrivacyExportJobRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PrivacyExportJobRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PrivacyExportJobRow> updateRow(
    _i1.Session session,
    PrivacyExportJobRow row, {
    _i1.ColumnSelections<PrivacyExportJobRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PrivacyExportJobRow>(
      row,
      columns: columns?.call(PrivacyExportJobRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PrivacyExportJobRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PrivacyExportJobRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PrivacyExportJobRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PrivacyExportJobRow>(
      id,
      columnValues: columnValues(PrivacyExportJobRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PrivacyExportJobRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PrivacyExportJobRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PrivacyExportJobRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PrivacyExportJobRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PrivacyExportJobRowTable>? orderBy,
    _i1.OrderByListBuilder<PrivacyExportJobRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PrivacyExportJobRow>(
      columnValues: columnValues(PrivacyExportJobRow.t.updateTable),
      where: where(PrivacyExportJobRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PrivacyExportJobRow.t),
      orderByList: orderByList?.call(PrivacyExportJobRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PrivacyExportJobRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PrivacyExportJobRow>> delete(
    _i1.Session session,
    List<PrivacyExportJobRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PrivacyExportJobRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PrivacyExportJobRow].
  Future<PrivacyExportJobRow> deleteRow(
    _i1.Session session,
    PrivacyExportJobRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PrivacyExportJobRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PrivacyExportJobRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PrivacyExportJobRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PrivacyExportJobRow>(
      where: where(PrivacyExportJobRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PrivacyExportJobRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PrivacyExportJobRow>(
      where: where?.call(PrivacyExportJobRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
