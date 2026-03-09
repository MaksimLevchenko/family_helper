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

abstract class FamilyInviteRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FamilyInviteRow._({
    this.id,
    required this.familyId,
    required this.inviteType,
    this.email,
    required this.inviteCode,
    required this.token,
    required this.expiresAt,
    this.acceptedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory FamilyInviteRow({
    int? id,
    required int familyId,
    required String inviteType,
    String? email,
    required String inviteCode,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _FamilyInviteRowImpl;

  factory FamilyInviteRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyInviteRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      inviteType: jsonSerialization['inviteType'] as String,
      email: jsonSerialization['email'] as String?,
      inviteCode: jsonSerialization['inviteCode'] as String,
      token: jsonSerialization['token'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = FamilyInviteRowTable();

  static const db = FamilyInviteRowRepository._();

  @override
  int? id;

  int familyId;

  String inviteType;

  String? email;

  String inviteCode;

  String token;

  DateTime expiresAt;

  DateTime? acceptedAt;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FamilyInviteRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyInviteRow copyWith({
    int? id,
    int? familyId,
    String? inviteType,
    String? email,
    String? inviteCode,
    String? token,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyInviteRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'inviteType': inviteType,
      if (email != null) 'email': email,
      'inviteCode': inviteCode,
      'token': token,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyInviteRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'inviteType': inviteType,
      if (email != null) 'email': email,
      'inviteCode': inviteCode,
      'token': token,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static FamilyInviteRowInclude include() {
    return FamilyInviteRowInclude._();
  }

  static FamilyInviteRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FamilyInviteRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyInviteRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyInviteRowTable>? orderByList,
    FamilyInviteRowInclude? include,
  }) {
    return FamilyInviteRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyInviteRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FamilyInviteRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyInviteRowImpl extends FamilyInviteRow {
  _FamilyInviteRowImpl({
    int? id,
    required int familyId,
    required String inviteType,
    String? email,
    required String inviteCode,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         inviteType: inviteType,
         email: email,
         inviteCode: inviteCode,
         token: token,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyInviteRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyInviteRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? inviteType,
    Object? email = _Undefined,
    String? inviteCode,
    String? token,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return FamilyInviteRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      inviteType: inviteType ?? this.inviteType,
      email: email is String? ? email : this.email,
      inviteCode: inviteCode ?? this.inviteCode,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class FamilyInviteRowUpdateTable extends _i1.UpdateTable<FamilyInviteRowTable> {
  FamilyInviteRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<String, String> inviteType(String value) => _i1.ColumnValue(
    table.inviteType,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> inviteCode(String value) => _i1.ColumnValue(
    table.inviteCode,
    value,
  );

  _i1.ColumnValue<String, String> token(String value) => _i1.ColumnValue(
    table.token,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> acceptedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.acceptedAt,
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

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
    value,
  );
}

class FamilyInviteRowTable extends _i1.Table<int?> {
  FamilyInviteRowTable({super.tableRelation})
    : super(tableName: 'family_invite') {
    updateTable = FamilyInviteRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    inviteType = _i1.ColumnString(
      'inviteType',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    inviteCode = _i1.ColumnString(
      'inviteCode',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    acceptedAt = _i1.ColumnDateTime(
      'acceptedAt',
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
    version = _i1.ColumnInt(
      'version',
      this,
    );
  }

  late final FamilyInviteRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  late final _i1.ColumnString inviteType;

  late final _i1.ColumnString email;

  late final _i1.ColumnString inviteCode;

  late final _i1.ColumnString token;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime acceptedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt version;

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    inviteType,
    email,
    inviteCode,
    token,
    expiresAt,
    acceptedAt,
    createdAt,
    updatedAt,
    version,
  ];
}

class FamilyInviteRowInclude extends _i1.IncludeObject {
  FamilyInviteRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FamilyInviteRow.t;
}

class FamilyInviteRowIncludeList extends _i1.IncludeList {
  FamilyInviteRowIncludeList._({
    _i1.WhereExpressionBuilder<FamilyInviteRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FamilyInviteRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FamilyInviteRow.t;
}

class FamilyInviteRowRepository {
  const FamilyInviteRowRepository._();

  /// Returns a list of [FamilyInviteRow]s matching the given query parameters.
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
  Future<List<FamilyInviteRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyInviteRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyInviteRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyInviteRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FamilyInviteRow>(
      where: where?.call(FamilyInviteRow.t),
      orderBy: orderBy?.call(FamilyInviteRow.t),
      orderByList: orderByList?.call(FamilyInviteRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [FamilyInviteRow] matching the given query parameters.
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
  Future<FamilyInviteRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyInviteRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FamilyInviteRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyInviteRowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FamilyInviteRow>(
      where: where?.call(FamilyInviteRow.t),
      orderBy: orderBy?.call(FamilyInviteRow.t),
      orderByList: orderByList?.call(FamilyInviteRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [FamilyInviteRow] by its [id] or null if no such row exists.
  Future<FamilyInviteRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FamilyInviteRow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [FamilyInviteRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FamilyInviteRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FamilyInviteRow>> insert(
    _i1.Session session,
    List<FamilyInviteRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FamilyInviteRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FamilyInviteRow] and returns the inserted row.
  ///
  /// The returned [FamilyInviteRow] will have its `id` field set.
  Future<FamilyInviteRow> insertRow(
    _i1.Session session,
    FamilyInviteRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FamilyInviteRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FamilyInviteRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FamilyInviteRow>> update(
    _i1.Session session,
    List<FamilyInviteRow> rows, {
    _i1.ColumnSelections<FamilyInviteRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FamilyInviteRow>(
      rows,
      columns: columns?.call(FamilyInviteRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyInviteRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FamilyInviteRow> updateRow(
    _i1.Session session,
    FamilyInviteRow row, {
    _i1.ColumnSelections<FamilyInviteRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FamilyInviteRow>(
      row,
      columns: columns?.call(FamilyInviteRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyInviteRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FamilyInviteRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FamilyInviteRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FamilyInviteRow>(
      id,
      columnValues: columnValues(FamilyInviteRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FamilyInviteRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FamilyInviteRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FamilyInviteRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FamilyInviteRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyInviteRowTable>? orderBy,
    _i1.OrderByListBuilder<FamilyInviteRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FamilyInviteRow>(
      columnValues: columnValues(FamilyInviteRow.t.updateTable),
      where: where(FamilyInviteRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyInviteRow.t),
      orderByList: orderByList?.call(FamilyInviteRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FamilyInviteRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FamilyInviteRow>> delete(
    _i1.Session session,
    List<FamilyInviteRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FamilyInviteRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FamilyInviteRow].
  Future<FamilyInviteRow> deleteRow(
    _i1.Session session,
    FamilyInviteRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FamilyInviteRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FamilyInviteRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FamilyInviteRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FamilyInviteRow>(
      where: where(FamilyInviteRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyInviteRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FamilyInviteRow>(
      where: where?.call(FamilyInviteRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
