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
import '../../family/models/family_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_server/src/generated/protocol.dart' as _i4;

abstract class FamilyMemberRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FamilyMemberRow._({
    this.id,
    required this.familyId,
    this.family,
    required this.profileId,
    this.profile,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory FamilyMemberRow({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required int profileId,
    _i3.AppProfileRow? profile,
    required String role,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _FamilyMemberRowImpl;

  factory FamilyMemberRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyMemberRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FamilyRow>(
              jsonSerialization['family'],
            ),
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['profile'],
            ),
      role: jsonSerialization['role'] as String,
      status: jsonSerialization['status'] as String,
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

  static final t = FamilyMemberRowTable();

  static const db = FamilyMemberRowRepository._();

  @override
  int? id;

  int familyId;

  _i2.FamilyRow? family;

  int profileId;

  _i3.AppProfileRow? profile;

  String role;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FamilyMemberRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyMemberRow copyWith({
    int? id,
    int? familyId,
    _i2.FamilyRow? family,
    int? profileId,
    _i3.AppProfileRow? profile,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyMemberRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJson(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'role': role,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyMemberRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJsonForProtocol(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'role': role,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static FamilyMemberRowInclude include({
    _i2.FamilyRowInclude? family,
    _i3.AppProfileRowInclude? profile,
  }) {
    return FamilyMemberRowInclude._(
      family: family,
      profile: profile,
    );
  }

  static FamilyMemberRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FamilyMemberRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyMemberRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyMemberRowTable>? orderByList,
    FamilyMemberRowInclude? include,
  }) {
    return FamilyMemberRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyMemberRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FamilyMemberRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyMemberRowImpl extends FamilyMemberRow {
  _FamilyMemberRowImpl({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required int profileId,
    _i3.AppProfileRow? profile,
    required String role,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         family: family,
         profileId: profileId,
         profile: profile,
         role: role,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyMemberRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyMemberRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    Object? family = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return FamilyMemberRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      family: family is _i2.FamilyRow? ? family : this.family?.copyWith(),
      profileId: profileId ?? this.profileId,
      profile: profile is _i3.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class FamilyMemberRowUpdateTable extends _i1.UpdateTable<FamilyMemberRowTable> {
  FamilyMemberRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

class FamilyMemberRowTable extends _i1.Table<int?> {
  FamilyMemberRowTable({super.tableRelation})
    : super(tableName: 'family_member') {
    updateTable = FamilyMemberRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    status = _i1.ColumnString(
      'status',
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

  late final FamilyMemberRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  _i2.FamilyRowTable? _family;

  late final _i1.ColumnInt profileId;

  _i3.AppProfileRowTable? _profile;

  late final _i1.ColumnString role;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  _i2.FamilyRowTable get family {
    if (_family != null) return _family!;
    _family = _i1.createRelationTable(
      relationFieldName: 'family',
      field: FamilyMemberRow.t.familyId,
      foreignField: _i2.FamilyRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.FamilyRowTable(tableRelation: foreignTableRelation),
    );
    return _family!;
  }

  _i3.AppProfileRowTable get profile {
    if (_profile != null) return _profile!;
    _profile = _i1.createRelationTable(
      relationFieldName: 'profile',
      field: FamilyMemberRow.t.profileId,
      foreignField: _i3.AppProfileRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AppProfileRowTable(tableRelation: foreignTableRelation),
    );
    return _profile!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    profileId,
    role,
    status,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'family') {
      return family;
    }
    if (relationField == 'profile') {
      return profile;
    }
    return null;
  }
}

class FamilyMemberRowInclude extends _i1.IncludeObject {
  FamilyMemberRowInclude._({
    _i2.FamilyRowInclude? family,
    _i3.AppProfileRowInclude? profile,
  }) {
    _family = family;
    _profile = profile;
  }

  _i2.FamilyRowInclude? _family;

  _i3.AppProfileRowInclude? _profile;

  @override
  Map<String, _i1.Include?> get includes => {
    'family': _family,
    'profile': _profile,
  };

  @override
  _i1.Table<int?> get table => FamilyMemberRow.t;
}

class FamilyMemberRowIncludeList extends _i1.IncludeList {
  FamilyMemberRowIncludeList._({
    _i1.WhereExpressionBuilder<FamilyMemberRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FamilyMemberRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FamilyMemberRow.t;
}

class FamilyMemberRowRepository {
  const FamilyMemberRowRepository._();

  final attachRow = const FamilyMemberRowAttachRowRepository._();

  /// Returns a list of [FamilyMemberRow]s matching the given query parameters.
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
  Future<List<FamilyMemberRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyMemberRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyMemberRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyMemberRowTable>? orderByList,
    _i1.Transaction? transaction,
    FamilyMemberRowInclude? include,
  }) async {
    return session.db.find<FamilyMemberRow>(
      where: where?.call(FamilyMemberRow.t),
      orderBy: orderBy?.call(FamilyMemberRow.t),
      orderByList: orderByList?.call(FamilyMemberRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [FamilyMemberRow] matching the given query parameters.
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
  Future<FamilyMemberRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyMemberRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FamilyMemberRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FamilyMemberRowTable>? orderByList,
    _i1.Transaction? transaction,
    FamilyMemberRowInclude? include,
  }) async {
    return session.db.findFirstRow<FamilyMemberRow>(
      where: where?.call(FamilyMemberRow.t),
      orderBy: orderBy?.call(FamilyMemberRow.t),
      orderByList: orderByList?.call(FamilyMemberRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [FamilyMemberRow] by its [id] or null if no such row exists.
  Future<FamilyMemberRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    FamilyMemberRowInclude? include,
  }) async {
    return session.db.findById<FamilyMemberRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [FamilyMemberRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FamilyMemberRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FamilyMemberRow>> insert(
    _i1.Session session,
    List<FamilyMemberRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FamilyMemberRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FamilyMemberRow] and returns the inserted row.
  ///
  /// The returned [FamilyMemberRow] will have its `id` field set.
  Future<FamilyMemberRow> insertRow(
    _i1.Session session,
    FamilyMemberRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FamilyMemberRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FamilyMemberRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FamilyMemberRow>> update(
    _i1.Session session,
    List<FamilyMemberRow> rows, {
    _i1.ColumnSelections<FamilyMemberRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FamilyMemberRow>(
      rows,
      columns: columns?.call(FamilyMemberRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyMemberRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FamilyMemberRow> updateRow(
    _i1.Session session,
    FamilyMemberRow row, {
    _i1.ColumnSelections<FamilyMemberRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FamilyMemberRow>(
      row,
      columns: columns?.call(FamilyMemberRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyMemberRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FamilyMemberRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FamilyMemberRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FamilyMemberRow>(
      id,
      columnValues: columnValues(FamilyMemberRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FamilyMemberRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FamilyMemberRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FamilyMemberRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FamilyMemberRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FamilyMemberRowTable>? orderBy,
    _i1.OrderByListBuilder<FamilyMemberRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FamilyMemberRow>(
      columnValues: columnValues(FamilyMemberRow.t.updateTable),
      where: where(FamilyMemberRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyMemberRow.t),
      orderByList: orderByList?.call(FamilyMemberRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FamilyMemberRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FamilyMemberRow>> delete(
    _i1.Session session,
    List<FamilyMemberRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FamilyMemberRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FamilyMemberRow].
  Future<FamilyMemberRow> deleteRow(
    _i1.Session session,
    FamilyMemberRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FamilyMemberRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FamilyMemberRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FamilyMemberRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FamilyMemberRow>(
      where: where(FamilyMemberRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FamilyMemberRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FamilyMemberRow>(
      where: where?.call(FamilyMemberRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class FamilyMemberRowAttachRowRepository {
  const FamilyMemberRowAttachRowRepository._();

  /// Creates a relation between the given [FamilyMemberRow] and [FamilyRow]
  /// by setting the [FamilyMemberRow]'s foreign key `familyId` to refer to the [FamilyRow].
  Future<void> family(
    _i1.Session session,
    FamilyMemberRow familyMemberRow,
    _i2.FamilyRow family, {
    _i1.Transaction? transaction,
  }) async {
    if (familyMemberRow.id == null) {
      throw ArgumentError.notNull('familyMemberRow.id');
    }
    if (family.id == null) {
      throw ArgumentError.notNull('family.id');
    }

    var $familyMemberRow = familyMemberRow.copyWith(familyId: family.id);
    await session.db.updateRow<FamilyMemberRow>(
      $familyMemberRow,
      columns: [FamilyMemberRow.t.familyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [FamilyMemberRow] and [AppProfileRow]
  /// by setting the [FamilyMemberRow]'s foreign key `profileId` to refer to the [AppProfileRow].
  Future<void> profile(
    _i1.Session session,
    FamilyMemberRow familyMemberRow,
    _i3.AppProfileRow profile, {
    _i1.Transaction? transaction,
  }) async {
    if (familyMemberRow.id == null) {
      throw ArgumentError.notNull('familyMemberRow.id');
    }
    if (profile.id == null) {
      throw ArgumentError.notNull('profile.id');
    }

    var $familyMemberRow = familyMemberRow.copyWith(profileId: profile.id);
    await session.db.updateRow<FamilyMemberRow>(
      $familyMemberRow,
      columns: [FamilyMemberRow.t.profileId],
      transaction: transaction,
    );
  }
}
