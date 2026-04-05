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

abstract class CalendarEventRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CalendarEventRow._({
    this.id,
    required this.familyId,
    this.family,
    required this.title,
    this.description,
    required this.timezone,
    required this.startsAt,
    required this.endsAt,
    this.rrule,
    this.reminderOffsetMinutes,
    this.colorKey,
    this.category,
    required this.createdByProfileId,
    this.createdByProfile,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory CalendarEventRow({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required String title,
    String? description,
    required String timezone,
    required DateTime startsAt,
    required DateTime endsAt,
    String? rrule,
    int? reminderOffsetMinutes,
    String? colorKey,
    String? category,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _CalendarEventRowImpl;

  factory CalendarEventRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarEventRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FamilyRow>(
              jsonSerialization['family'],
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      timezone: jsonSerialization['timezone'] as String,
      startsAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startsAt'],
      ),
      endsAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
      rrule: jsonSerialization['rrule'] as String?,
      reminderOffsetMinutes: jsonSerialization['reminderOffsetMinutes'] as int?,
      colorKey: jsonSerialization['colorKey'] as String?,
      category: jsonSerialization['category'] as String?,
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

  static final t = CalendarEventRowTable();

  static const db = CalendarEventRowRepository._();

  @override
  int? id;

  int familyId;

  _i2.FamilyRow? family;

  String title;

  String? description;

  String timezone;

  DateTime startsAt;

  DateTime endsAt;

  String? rrule;

  int? reminderOffsetMinutes;

  String? colorKey;

  String? category;

  int createdByProfileId;

  _i3.AppProfileRow? createdByProfile;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CalendarEventRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarEventRow copyWith({
    int? id,
    int? familyId,
    _i2.FamilyRow? family,
    String? title,
    String? description,
    String? timezone,
    DateTime? startsAt,
    DateTime? endsAt,
    String? rrule,
    int? reminderOffsetMinutes,
    String? colorKey,
    String? category,
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
      '__className__': 'CalendarEventRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'timezone': timezone,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      if (rrule != null) 'rrule': rrule,
      if (reminderOffsetMinutes != null)
        'reminderOffsetMinutes': reminderOffsetMinutes,
      if (colorKey != null) 'colorKey': colorKey,
      if (category != null) 'category': category,
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
      '__className__': 'CalendarEventRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (family != null) 'family': family?.toJsonForProtocol(),
      'title': title,
      if (description != null) 'description': description,
      'timezone': timezone,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      if (rrule != null) 'rrule': rrule,
      if (reminderOffsetMinutes != null)
        'reminderOffsetMinutes': reminderOffsetMinutes,
      if (colorKey != null) 'colorKey': colorKey,
      if (category != null) 'category': category,
      'createdByProfileId': createdByProfileId,
      if (createdByProfile != null)
        'createdByProfile': createdByProfile?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  static CalendarEventRowInclude include({
    _i2.FamilyRowInclude? family,
    _i3.AppProfileRowInclude? createdByProfile,
  }) {
    return CalendarEventRowInclude._(
      family: family,
      createdByProfile: createdByProfile,
    );
  }

  static CalendarEventRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CalendarEventRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventRowTable>? orderByList,
    CalendarEventRowInclude? include,
  }) {
    return CalendarEventRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CalendarEventRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarEventRowImpl extends CalendarEventRow {
  _CalendarEventRowImpl({
    int? id,
    required int familyId,
    _i2.FamilyRow? family,
    required String title,
    String? description,
    required String timezone,
    required DateTime startsAt,
    required DateTime endsAt,
    String? rrule,
    int? reminderOffsetMinutes,
    String? colorKey,
    String? category,
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
         timezone: timezone,
         startsAt: startsAt,
         endsAt: endsAt,
         rrule: rrule,
         reminderOffsetMinutes: reminderOffsetMinutes,
         colorKey: colorKey,
         category: category,
         createdByProfileId: createdByProfileId,
         createdByProfile: createdByProfile,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CalendarEventRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarEventRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    Object? family = _Undefined,
    String? title,
    Object? description = _Undefined,
    String? timezone,
    DateTime? startsAt,
    DateTime? endsAt,
    Object? rrule = _Undefined,
    Object? reminderOffsetMinutes = _Undefined,
    Object? colorKey = _Undefined,
    Object? category = _Undefined,
    int? createdByProfileId,
    Object? createdByProfile = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return CalendarEventRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      family: family is _i2.FamilyRow? ? family : this.family?.copyWith(),
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      timezone: timezone ?? this.timezone,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      rrule: rrule is String? ? rrule : this.rrule,
      reminderOffsetMinutes: reminderOffsetMinutes is int?
          ? reminderOffsetMinutes
          : this.reminderOffsetMinutes,
      colorKey: colorKey is String? ? colorKey : this.colorKey,
      category: category is String? ? category : this.category,
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

class CalendarEventRowUpdateTable
    extends _i1.UpdateTable<CalendarEventRowTable> {
  CalendarEventRowUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> timezone(String value) => _i1.ColumnValue(
    table.timezone,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startsAt(DateTime value) =>
      _i1.ColumnValue(
        table.startsAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endsAt(DateTime value) => _i1.ColumnValue(
    table.endsAt,
    value,
  );

  _i1.ColumnValue<String, String> rrule(String? value) => _i1.ColumnValue(
    table.rrule,
    value,
  );

  _i1.ColumnValue<int, int> reminderOffsetMinutes(int? value) =>
      _i1.ColumnValue(
        table.reminderOffsetMinutes,
        value,
      );

  _i1.ColumnValue<String, String> colorKey(String? value) => _i1.ColumnValue(
    table.colorKey,
    value,
  );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
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

class CalendarEventRowTable extends _i1.Table<int?> {
  CalendarEventRowTable({super.tableRelation})
    : super(tableName: 'calendar_event') {
    updateTable = CalendarEventRowUpdateTable(this);
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
    timezone = _i1.ColumnString(
      'timezone',
      this,
    );
    startsAt = _i1.ColumnDateTime(
      'startsAt',
      this,
    );
    endsAt = _i1.ColumnDateTime(
      'endsAt',
      this,
    );
    rrule = _i1.ColumnString(
      'rrule',
      this,
    );
    reminderOffsetMinutes = _i1.ColumnInt(
      'reminderOffsetMinutes',
      this,
    );
    colorKey = _i1.ColumnString(
      'colorKey',
      this,
    );
    category = _i1.ColumnString(
      'category',
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

  late final CalendarEventRowUpdateTable updateTable;

  late final _i1.ColumnInt familyId;

  _i2.FamilyRowTable? _family;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString timezone;

  late final _i1.ColumnDateTime startsAt;

  late final _i1.ColumnDateTime endsAt;

  late final _i1.ColumnString rrule;

  late final _i1.ColumnInt reminderOffsetMinutes;

  late final _i1.ColumnString colorKey;

  late final _i1.ColumnString category;

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
      field: CalendarEventRow.t.familyId,
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
      field: CalendarEventRow.t.createdByProfileId,
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
    timezone,
    startsAt,
    endsAt,
    rrule,
    reminderOffsetMinutes,
    colorKey,
    category,
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

class CalendarEventRowInclude extends _i1.IncludeObject {
  CalendarEventRowInclude._({
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
  _i1.Table<int?> get table => CalendarEventRow.t;
}

class CalendarEventRowIncludeList extends _i1.IncludeList {
  CalendarEventRowIncludeList._({
    _i1.WhereExpressionBuilder<CalendarEventRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CalendarEventRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CalendarEventRow.t;
}

class CalendarEventRowRepository {
  const CalendarEventRowRepository._();

  final attachRow = const CalendarEventRowAttachRowRepository._();

  /// Returns a list of [CalendarEventRow]s matching the given query parameters.
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
  Future<List<CalendarEventRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventRowTable>? orderByList,
    _i1.Transaction? transaction,
    CalendarEventRowInclude? include,
  }) async {
    return session.db.find<CalendarEventRow>(
      where: where?.call(CalendarEventRow.t),
      orderBy: orderBy?.call(CalendarEventRow.t),
      orderByList: orderByList?.call(CalendarEventRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [CalendarEventRow] matching the given query parameters.
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
  Future<CalendarEventRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CalendarEventRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventRowTable>? orderByList,
    _i1.Transaction? transaction,
    CalendarEventRowInclude? include,
  }) async {
    return session.db.findFirstRow<CalendarEventRow>(
      where: where?.call(CalendarEventRow.t),
      orderBy: orderBy?.call(CalendarEventRow.t),
      orderByList: orderByList?.call(CalendarEventRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CalendarEventRow] by its [id] or null if no such row exists.
  Future<CalendarEventRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CalendarEventRowInclude? include,
  }) async {
    return session.db.findById<CalendarEventRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CalendarEventRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CalendarEventRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CalendarEventRow>> insert(
    _i1.Session session,
    List<CalendarEventRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CalendarEventRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CalendarEventRow] and returns the inserted row.
  ///
  /// The returned [CalendarEventRow] will have its `id` field set.
  Future<CalendarEventRow> insertRow(
    _i1.Session session,
    CalendarEventRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CalendarEventRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CalendarEventRow>> update(
    _i1.Session session,
    List<CalendarEventRow> rows, {
    _i1.ColumnSelections<CalendarEventRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CalendarEventRow>(
      rows,
      columns: columns?.call(CalendarEventRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarEventRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CalendarEventRow> updateRow(
    _i1.Session session,
    CalendarEventRow row, {
    _i1.ColumnSelections<CalendarEventRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CalendarEventRow>(
      row,
      columns: columns?.call(CalendarEventRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarEventRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CalendarEventRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CalendarEventRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CalendarEventRow>(
      id,
      columnValues: columnValues(CalendarEventRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CalendarEventRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CalendarEventRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CalendarEventRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventRowTable>? orderBy,
    _i1.OrderByListBuilder<CalendarEventRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CalendarEventRow>(
      columnValues: columnValues(CalendarEventRow.t.updateTable),
      where: where(CalendarEventRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventRow.t),
      orderByList: orderByList?.call(CalendarEventRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CalendarEventRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CalendarEventRow>> delete(
    _i1.Session session,
    List<CalendarEventRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CalendarEventRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CalendarEventRow].
  Future<CalendarEventRow> deleteRow(
    _i1.Session session,
    CalendarEventRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CalendarEventRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CalendarEventRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CalendarEventRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CalendarEventRow>(
      where: where(CalendarEventRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CalendarEventRow>(
      where: where?.call(CalendarEventRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CalendarEventRowAttachRowRepository {
  const CalendarEventRowAttachRowRepository._();

  /// Creates a relation between the given [CalendarEventRow] and [FamilyRow]
  /// by setting the [CalendarEventRow]'s foreign key `familyId` to refer to the [FamilyRow].
  Future<void> family(
    _i1.Session session,
    CalendarEventRow calendarEventRow,
    _i2.FamilyRow family, {
    _i1.Transaction? transaction,
  }) async {
    if (calendarEventRow.id == null) {
      throw ArgumentError.notNull('calendarEventRow.id');
    }
    if (family.id == null) {
      throw ArgumentError.notNull('family.id');
    }

    var $calendarEventRow = calendarEventRow.copyWith(familyId: family.id);
    await session.db.updateRow<CalendarEventRow>(
      $calendarEventRow,
      columns: [CalendarEventRow.t.familyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CalendarEventRow] and [AppProfileRow]
  /// by setting the [CalendarEventRow]'s foreign key `createdByProfileId` to refer to the [AppProfileRow].
  Future<void> createdByProfile(
    _i1.Session session,
    CalendarEventRow calendarEventRow,
    _i3.AppProfileRow createdByProfile, {
    _i1.Transaction? transaction,
  }) async {
    if (calendarEventRow.id == null) {
      throw ArgumentError.notNull('calendarEventRow.id');
    }
    if (createdByProfile.id == null) {
      throw ArgumentError.notNull('createdByProfile.id');
    }

    var $calendarEventRow = calendarEventRow.copyWith(
      createdByProfileId: createdByProfile.id,
    );
    await session.db.updateRow<CalendarEventRow>(
      $calendarEventRow,
      columns: [CalendarEventRow.t.createdByProfileId],
      transaction: transaction,
    );
  }
}
