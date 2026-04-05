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

abstract class ReminderRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReminderRow._({
    this.id,
    required this.familyId,
    this.family,
    required this.entityType,
    required this.entityId,
    required this.profileId,
    this.profile,
    required this.remindAt,
    required this.status,
    required this.payloadJson,
    this.clientOperationId,
    this.firedAt,
    required this.createdAt,
  });

  factory ReminderRow({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required String entityType,
    required int entityId,
    required int profileId,
    _i3.AppProfileRow? profile,
    required DateTime remindAt,
    required String status,
    required String payloadJson,
    String? clientOperationId,
    DateTime? firedAt,
    required DateTime createdAt,
  }) = _ReminderRowImpl;

  factory ReminderRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FamilyRow>(
              jsonSerialization['family'],
            ),
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['profile'],
            ),
      remindAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['remindAt'],
      ),
      status: jsonSerialization['status'] as String,
      payloadJson: jsonSerialization['payloadJson'] as String,
      clientOperationId: jsonSerialization['clientOperationId'] as String?,
      firedAt: jsonSerialization['firedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['firedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ReminderRowTable();

  static const db = ReminderRowRepository._();

  @override
  int? id;

  int familyId;

  _i2.FamilyRow? family;

  String entityType;

  int entityId;

  int profileId;

  _i3.AppProfileRow? profile;

  DateTime remindAt;

  String status;

  String payloadJson;

  String? clientOperationId;

  DateTime? firedAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReminderRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReminderRow copyWith({
    int? id,
    int? familyId,
    _i2.FamilyRow? family,
    String? entityType,
    int? entityId,
    int? profileId,
    _i3.AppProfileRow? profile,
    DateTime? remindAt,
    String? status,
    String? payloadJson,
    String? clientOperationId,
    DateTime? firedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJson(),
      'entityType': entityType,
      'entityId': entityId,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'remindAt': remindAt.toJson(),
      'status': status,
      'payloadJson': payloadJson,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJsonForProtocol(),
      'entityType': entityType,
      'entityId': entityId,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'remindAt': remindAt.toJson(),
      'status': status,
      'payloadJson': payloadJson,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ReminderRowInclude include({
    _i2.FamilyRowInclude? family,
    _i3.AppProfileRowInclude? profile,
  }) {
    return ReminderRowInclude._(
      family: family,
      profile: profile,
    );
  }

  static ReminderRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ReminderRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReminderRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReminderRowTable>? orderByList,
    ReminderRowInclude? include,
  }) {
    return ReminderRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReminderRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReminderRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderRowImpl extends ReminderRow {
  _ReminderRowImpl({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required String entityType,
    required int entityId,
    required int profileId,
    _i3.AppProfileRow? profile,
    required DateTime remindAt,
    required String status,
    required String payloadJson,
    String? clientOperationId,
    DateTime? firedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         family: family,
         entityType: entityType,
         entityId: entityId,
         profileId: profileId,
         profile: profile,
         remindAt: remindAt,
         status: status,
         payloadJson: payloadJson,
         clientOperationId: clientOperationId,
         firedAt: firedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReminderRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReminderRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    Object? family = _Undefined,
    String? entityType,
    int? entityId,
    int? profileId,
    Object? profile = _Undefined,
    DateTime? remindAt,
    String? status,
    String? payloadJson,
    Object? clientOperationId = _Undefined,
    Object? firedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return ReminderRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      family: family is _i2.FamilyRow? ? family : this.family?.copyWith(),
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      profileId: profileId ?? this.profileId,
      profile: profile is _i3.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      remindAt: remindAt ?? this.remindAt,
      status: status ?? this.status,
      payloadJson: payloadJson ?? this.payloadJson,
      clientOperationId: clientOperationId is String?
          ? clientOperationId
          : this.clientOperationId,
      firedAt: firedAt is DateTime? ? firedAt : this.firedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReminderRowUpdateTable extends _i1.UpdateTable<ReminderRowTable> {
  ReminderRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> familyId(int value) => _i1.ColumnValue(
    table.familyId,
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

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> remindAt(DateTime value) =>
      _i1.ColumnValue(
        table.remindAt,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> payloadJson(String value) => _i1.ColumnValue(
    table.payloadJson,
    value,
  );

  _i1.ColumnValue<String, String> clientOperationId(String? value) =>
      _i1.ColumnValue(
        table.clientOperationId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> firedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.firedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReminderRowTable extends _i1.Table<int?> {
  ReminderRowTable({super.tableRelation}) : super(tableName: 'reminder') {
    updateTable = ReminderRowUpdateTable(this);
    familyId = _i1.ColumnInt(
      'familyId',
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
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    remindAt = _i1.ColumnDateTime(
      'remindAt',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    payloadJson = _i1.ColumnString(
      'payloadJson',
      this,
    );
    clientOperationId = _i1.ColumnString(
      'clientOperationId',
      this,
    );
    firedAt = _i1.ColumnDateTime(
      'firedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ReminderRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  _i2.FamilyRowTable? _family;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnInt entityId;

  late final _i1.ColumnInt profileId;

  _i3.AppProfileRowTable? _profile;

  late final _i1.ColumnDateTime remindAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnString payloadJson;

  late final _i1.ColumnString clientOperationId;

  late final _i1.ColumnDateTime firedAt;

  late final _i1.ColumnDateTime createdAt;

  _i2.FamilyRowTable get family {
    if (_family != null) return _family!;
    _family = _i1.createRelationTable(
      relationFieldName: 'family',
      field: ReminderRow.t.familyId,
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
      field: ReminderRow.t.profileId,
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
    entityType,
    entityId,
    profileId,
    remindAt,
    status,
    payloadJson,
    clientOperationId,
    firedAt,
    createdAt,
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

class ReminderRowInclude extends _i1.IncludeObject {
  ReminderRowInclude._({
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
  _i1.Table<int?> get table => ReminderRow.t;
}

class ReminderRowIncludeList extends _i1.IncludeList {
  ReminderRowIncludeList._({
    _i1.WhereExpressionBuilder<ReminderRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReminderRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReminderRow.t;
}

class ReminderRowRepository {
  const ReminderRowRepository._();

  final attachRow = const ReminderRowAttachRowRepository._();

  /// Returns a list of [ReminderRow]s matching the given query parameters.
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
  Future<List<ReminderRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReminderRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReminderRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReminderRowTable>? orderByList,
    _i1.Transaction? transaction,
    ReminderRowInclude? include,
  }) async {
    return session.db.find<ReminderRow>(
      where: where?.call(ReminderRow.t),
      orderBy: orderBy?.call(ReminderRow.t),
      orderByList: orderByList?.call(ReminderRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ReminderRow] matching the given query parameters.
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
  Future<ReminderRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReminderRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReminderRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReminderRowTable>? orderByList,
    _i1.Transaction? transaction,
    ReminderRowInclude? include,
  }) async {
    return session.db.findFirstRow<ReminderRow>(
      where: where?.call(ReminderRow.t),
      orderBy: orderBy?.call(ReminderRow.t),
      orderByList: orderByList?.call(ReminderRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ReminderRow] by its [id] or null if no such row exists.
  Future<ReminderRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ReminderRowInclude? include,
  }) async {
    return session.db.findById<ReminderRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ReminderRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ReminderRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReminderRow>> insert(
    _i1.Session session,
    List<ReminderRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReminderRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReminderRow] and returns the inserted row.
  ///
  /// The returned [ReminderRow] will have its `id` field set.
  Future<ReminderRow> insertRow(
    _i1.Session session,
    ReminderRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReminderRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReminderRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReminderRow>> update(
    _i1.Session session,
    List<ReminderRow> rows, {
    _i1.ColumnSelections<ReminderRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReminderRow>(
      rows,
      columns: columns?.call(ReminderRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReminderRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReminderRow> updateRow(
    _i1.Session session,
    ReminderRow row, {
    _i1.ColumnSelections<ReminderRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReminderRow>(
      row,
      columns: columns?.call(ReminderRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReminderRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReminderRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReminderRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReminderRow>(
      id,
      columnValues: columnValues(ReminderRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReminderRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReminderRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReminderRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReminderRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReminderRowTable>? orderBy,
    _i1.OrderByListBuilder<ReminderRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReminderRow>(
      columnValues: columnValues(ReminderRow.t.updateTable),
      where: where(ReminderRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReminderRow.t),
      orderByList: orderByList?.call(ReminderRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReminderRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReminderRow>> delete(
    _i1.Session session,
    List<ReminderRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReminderRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReminderRow].
  Future<ReminderRow> deleteRow(
    _i1.Session session,
    ReminderRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReminderRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReminderRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReminderRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReminderRow>(
      where: where(ReminderRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReminderRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReminderRow>(
      where: where?.call(ReminderRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ReminderRowAttachRowRepository {
  const ReminderRowAttachRowRepository._();

  /// Creates a relation between the given [ReminderRow] and [FamilyRow]
  /// by setting the [ReminderRow]'s foreign key `familyId` to refer to the [FamilyRow].
  Future<void> family(
    _i1.Session session,
    ReminderRow reminderRow,
    _i2.FamilyRow family, {
    _i1.Transaction? transaction,
  }) async {
    if (reminderRow.id == null) {
      throw ArgumentError.notNull('reminderRow.id');
    }
    if (family.id == null) {
      throw ArgumentError.notNull('family.id');
    }

    var $reminderRow = reminderRow.copyWith(familyId: family.id);
    await session.db.updateRow<ReminderRow>(
      $reminderRow,
      columns: [ReminderRow.t.familyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ReminderRow] and [AppProfileRow]
  /// by setting the [ReminderRow]'s foreign key `profileId` to refer to the [AppProfileRow].
  Future<void> profile(
    _i1.Session session,
    ReminderRow reminderRow,
    _i3.AppProfileRow profile, {
    _i1.Transaction? transaction,
  }) async {
    if (reminderRow.id == null) {
      throw ArgumentError.notNull('reminderRow.id');
    }
    if (profile.id == null) {
      throw ArgumentError.notNull('profile.id');
    }

    var $reminderRow = reminderRow.copyWith(profileId: profile.id);
    await session.db.updateRow<ReminderRow>(
      $reminderRow,
      columns: [ReminderRow.t.profileId],
      transaction: transaction,
    );
  }
}
