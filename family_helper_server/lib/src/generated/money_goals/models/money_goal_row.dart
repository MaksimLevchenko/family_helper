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

abstract class MoneyGoalRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MoneyGoalRow._({
    this.id,
    required this.familyId,
    this.family,
    required this.title,
    this.description,
    required this.targetAmountCents,
    required this.currentAmountCents,
    required this.currency,
    this.deadlineAt,
    this.reachedAt,
    this.archivedAt,
    required this.createdByProfileId,
    this.createdByProfile,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory MoneyGoalRow({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required String title,
    String? description,
    required int targetAmountCents,
    required int currentAmountCents,
    required String currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? archivedAt,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _MoneyGoalRowImpl;

  factory MoneyGoalRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MoneyGoalRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FamilyRow>(
              jsonSerialization['family'],
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      targetAmountCents: jsonSerialization['targetAmountCents'] as int,
      currentAmountCents: jsonSerialization['currentAmountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      deadlineAt: jsonSerialization['deadlineAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadlineAt']),
      reachedAt: jsonSerialization['reachedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['reachedAt']),
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['archivedAt']),
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      createdByProfile: jsonSerialization['createdByProfile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['createdByProfile'],
            ),
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

  static final t = MoneyGoalRowTable();

  static const db = MoneyGoalRowRepository._();

  @override
  int? id;

  int familyId;

  _i2.FamilyRow? family;

  String title;

  String? description;

  int targetAmountCents;

  int currentAmountCents;

  String currency;

  DateTime? deadlineAt;

  DateTime? reachedAt;

  DateTime? archivedAt;

  int createdByProfileId;

  _i3.AppProfileRow? createdByProfile;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MoneyGoalRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyGoalRow copyWith({
    int? id,
    int? familyId,
    _i2.FamilyRow? family,
    String? title,
    String? description,
    int? targetAmountCents,
    int? currentAmountCents,
    String? currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? archivedAt,
    int? createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyGoalRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'targetAmountCents': targetAmountCents,
      'currentAmountCents': currentAmountCents,
      'currency': currency,
      if (deadlineAt != null) 'deadlineAt': deadlineAt?.toJson(),
      if (reachedAt != null) 'reachedAt': reachedAt?.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      'createdByProfileId': createdByProfileId,
      if (createdByProfile != null)
        'createdByProfile': createdByProfile?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MoneyGoalRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJsonForProtocol(),
      'title': title,
      if (description != null) 'description': description,
      'targetAmountCents': targetAmountCents,
      'currentAmountCents': currentAmountCents,
      'currency': currency,
      if (deadlineAt != null) 'deadlineAt': deadlineAt?.toJson(),
      if (reachedAt != null) 'reachedAt': reachedAt?.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      'createdByProfileId': createdByProfileId,
      if (createdByProfile != null)
        'createdByProfile': createdByProfile?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static MoneyGoalRowInclude include({
    _i2.FamilyRowInclude? family,
    _i3.AppProfileRowInclude? createdByProfile,
  }) {
    return MoneyGoalRowInclude._(
      family: family,
      createdByProfile: createdByProfile,
    );
  }

  static MoneyGoalRowIncludeList includeList({
    _i1.WhereExpressionBuilder<MoneyGoalRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MoneyGoalRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MoneyGoalRowTable>? orderByList,
    MoneyGoalRowInclude? include,
  }) {
    return MoneyGoalRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MoneyGoalRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MoneyGoalRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MoneyGoalRowImpl extends MoneyGoalRow {
  _MoneyGoalRowImpl({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required String title,
    String? description,
    required int targetAmountCents,
    required int currentAmountCents,
    required String currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? archivedAt,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         family: family,
         title: title,
         description: description,
         targetAmountCents: targetAmountCents,
         currentAmountCents: currentAmountCents,
         currency: currency,
         deadlineAt: deadlineAt,
         reachedAt: reachedAt,
         archivedAt: archivedAt,
         createdByProfileId: createdByProfileId,
         createdByProfile: createdByProfile,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MoneyGoalRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyGoalRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    Object? family = _Undefined,
    String? title,
    Object? description = _Undefined,
    int? targetAmountCents,
    int? currentAmountCents,
    String? currency,
    Object? deadlineAt = _Undefined,
    Object? reachedAt = _Undefined,
    Object? archivedAt = _Undefined,
    int? createdByProfileId,
    Object? createdByProfile = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MoneyGoalRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      family: family is _i2.FamilyRow? ? family : this.family?.copyWith(),
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      currentAmountCents: currentAmountCents ?? this.currentAmountCents,
      currency: currency ?? this.currency,
      deadlineAt: deadlineAt is DateTime? ? deadlineAt : this.deadlineAt,
      reachedAt: reachedAt is DateTime? ? reachedAt : this.reachedAt,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdByProfile: createdByProfile is _i3.AppProfileRow?
          ? createdByProfile
          : this.createdByProfile?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}

class MoneyGoalRowUpdateTable extends _i1.UpdateTable<MoneyGoalRowTable> {
  MoneyGoalRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<int, int> targetAmountCents(int value) => _i1.ColumnValue(
    table.targetAmountCents,
    value,
  );

  _i1.ColumnValue<int, int> currentAmountCents(int value) => _i1.ColumnValue(
    table.currentAmountCents,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deadlineAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deadlineAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> reachedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.reachedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> archivedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.archivedAt,
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

class MoneyGoalRowTable extends _i1.Table<int?> {
  MoneyGoalRowTable({super.tableRelation}) : super(tableName: 'money_goal') {
    updateTable = MoneyGoalRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    targetAmountCents = _i1.ColumnInt(
      'targetAmountCents',
      this,
    );
    currentAmountCents = _i1.ColumnInt(
      'currentAmountCents',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    deadlineAt = _i1.ColumnDateTime(
      'deadlineAt',
      this,
    );
    reachedAt = _i1.ColumnDateTime(
      'reachedAt',
      this,
    );
    archivedAt = _i1.ColumnDateTime(
      'archivedAt',
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

  late final MoneyGoalRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  _i2.FamilyRowTable? _family;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt targetAmountCents;

  late final _i1.ColumnInt currentAmountCents;

  late final _i1.ColumnString currency;

  late final _i1.ColumnDateTime deadlineAt;

  late final _i1.ColumnDateTime reachedAt;

  late final _i1.ColumnDateTime archivedAt;

  late final _i1.ColumnInt createdByProfileId;

  _i3.AppProfileRowTable? _createdByProfile;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnInt version;

  _i2.FamilyRowTable get family {
    if (_family != null) return _family!;
    _family = _i1.createRelationTable(
      relationFieldName: 'family',
      field: MoneyGoalRow.t.familyId,
      foreignField: _i2.FamilyRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.FamilyRowTable(tableRelation: foreignTableRelation),
    );
    return _family!;
  }

  _i3.AppProfileRowTable get createdByProfile {
    if (_createdByProfile != null) return _createdByProfile!;
    _createdByProfile = _i1.createRelationTable(
      relationFieldName: 'createdByProfile',
      field: MoneyGoalRow.t.createdByProfileId,
      foreignField: _i3.AppProfileRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AppProfileRowTable(tableRelation: foreignTableRelation),
    );
    return _createdByProfile!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    familyId,
    title,
    description,
    targetAmountCents,
    currentAmountCents,
    currency,
    deadlineAt,
    reachedAt,
    archivedAt,
    createdByProfileId,
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
    if (relationField == 'createdByProfile') {
      return createdByProfile;
    }
    return null;
  }
}

class MoneyGoalRowInclude extends _i1.IncludeObject {
  MoneyGoalRowInclude._({
    _i2.FamilyRowInclude? family,
    _i3.AppProfileRowInclude? createdByProfile,
  }) {
    _family = family;
    _createdByProfile = createdByProfile;
  }

  _i2.FamilyRowInclude? _family;

  _i3.AppProfileRowInclude? _createdByProfile;

  @override
  Map<String, _i1.Include?> get includes => {
    'family': _family,
    'createdByProfile': _createdByProfile,
  };

  @override
  _i1.Table<int?> get table => MoneyGoalRow.t;
}

class MoneyGoalRowIncludeList extends _i1.IncludeList {
  MoneyGoalRowIncludeList._({
    _i1.WhereExpressionBuilder<MoneyGoalRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MoneyGoalRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MoneyGoalRow.t;
}

class MoneyGoalRowRepository {
  const MoneyGoalRowRepository._();

  final attachRow = const MoneyGoalRowAttachRowRepository._();

  /// Returns a list of [MoneyGoalRow]s matching the given query parameters.
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
  Future<List<MoneyGoalRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MoneyGoalRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MoneyGoalRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MoneyGoalRowTable>? orderByList,
    _i1.Transaction? transaction,
    MoneyGoalRowInclude? include,
  }) async {
    return session.db.find<MoneyGoalRow>(
      where: where?.call(MoneyGoalRow.t),
      orderBy: orderBy?.call(MoneyGoalRow.t),
      orderByList: orderByList?.call(MoneyGoalRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [MoneyGoalRow] matching the given query parameters.
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
  Future<MoneyGoalRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MoneyGoalRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<MoneyGoalRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MoneyGoalRowTable>? orderByList,
    _i1.Transaction? transaction,
    MoneyGoalRowInclude? include,
  }) async {
    return session.db.findFirstRow<MoneyGoalRow>(
      where: where?.call(MoneyGoalRow.t),
      orderBy: orderBy?.call(MoneyGoalRow.t),
      orderByList: orderByList?.call(MoneyGoalRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [MoneyGoalRow] by its [id] or null if no such row exists.
  Future<MoneyGoalRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    MoneyGoalRowInclude? include,
  }) async {
    return session.db.findById<MoneyGoalRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [MoneyGoalRow]s in the list and returns the inserted rows.
  ///
  /// The returned [MoneyGoalRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MoneyGoalRow>> insert(
    _i1.Session session,
    List<MoneyGoalRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MoneyGoalRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MoneyGoalRow] and returns the inserted row.
  ///
  /// The returned [MoneyGoalRow] will have its `id` field set.
  Future<MoneyGoalRow> insertRow(
    _i1.Session session,
    MoneyGoalRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MoneyGoalRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MoneyGoalRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MoneyGoalRow>> update(
    _i1.Session session,
    List<MoneyGoalRow> rows, {
    _i1.ColumnSelections<MoneyGoalRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MoneyGoalRow>(
      rows,
      columns: columns?.call(MoneyGoalRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MoneyGoalRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MoneyGoalRow> updateRow(
    _i1.Session session,
    MoneyGoalRow row, {
    _i1.ColumnSelections<MoneyGoalRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MoneyGoalRow>(
      row,
      columns: columns?.call(MoneyGoalRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MoneyGoalRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MoneyGoalRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MoneyGoalRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MoneyGoalRow>(
      id,
      columnValues: columnValues(MoneyGoalRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MoneyGoalRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MoneyGoalRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MoneyGoalRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MoneyGoalRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MoneyGoalRowTable>? orderBy,
    _i1.OrderByListBuilder<MoneyGoalRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MoneyGoalRow>(
      columnValues: columnValues(MoneyGoalRow.t.updateTable),
      where: where(MoneyGoalRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MoneyGoalRow.t),
      orderByList: orderByList?.call(MoneyGoalRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MoneyGoalRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MoneyGoalRow>> delete(
    _i1.Session session,
    List<MoneyGoalRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MoneyGoalRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MoneyGoalRow].
  Future<MoneyGoalRow> deleteRow(
    _i1.Session session,
    MoneyGoalRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MoneyGoalRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MoneyGoalRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MoneyGoalRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MoneyGoalRow>(
      where: where(MoneyGoalRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MoneyGoalRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MoneyGoalRow>(
      where: where?.call(MoneyGoalRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class MoneyGoalRowAttachRowRepository {
  const MoneyGoalRowAttachRowRepository._();

  /// Creates a relation between the given [MoneyGoalRow] and [FamilyRow]
  /// by setting the [MoneyGoalRow]'s foreign key `familyId` to refer to the [FamilyRow].
  Future<void> family(
    _i1.Session session,
    MoneyGoalRow moneyGoalRow,
    _i2.FamilyRow family, {
    _i1.Transaction? transaction,
  }) async {
    if (moneyGoalRow.id == null) {
      throw ArgumentError.notNull('moneyGoalRow.id');
    }
    if (family.id == null) {
      throw ArgumentError.notNull('family.id');
    }

    var $moneyGoalRow = moneyGoalRow.copyWith(familyId: family.id);
    await session.db.updateRow<MoneyGoalRow>(
      $moneyGoalRow,
      columns: [MoneyGoalRow.t.familyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [MoneyGoalRow] and [AppProfileRow]
  /// by setting the [MoneyGoalRow]'s foreign key `createdByProfileId` to refer to the [AppProfileRow].
  Future<void> createdByProfile(
    _i1.Session session,
    MoneyGoalRow moneyGoalRow,
    _i3.AppProfileRow createdByProfile, {
    _i1.Transaction? transaction,
  }) async {
    if (moneyGoalRow.id == null) {
      throw ArgumentError.notNull('moneyGoalRow.id');
    }
    if (createdByProfile.id == null) {
      throw ArgumentError.notNull('createdByProfile.id');
    }

    var $moneyGoalRow = moneyGoalRow.copyWith(
      createdByProfileId: createdByProfile.id,
    );
    await session.db.updateRow<MoneyGoalRow>(
      $moneyGoalRow,
      columns: [MoneyGoalRow.t.createdByProfileId],
      transaction: transaction,
    );
  }
}
