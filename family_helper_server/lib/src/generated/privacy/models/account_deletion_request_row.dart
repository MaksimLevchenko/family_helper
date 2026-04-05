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
import '../../core/models/app_profile_row.dart' as _i2;
import 'package:family_helper_server/src/generated/protocol.dart' as _i3;

abstract class AccountDeletionRequestRow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountDeletionRequestRow._({
    this.id,
    required this.profileId,
    this.profile,
    required this.status,
    required this.scheduledHardDeleteAt,
    required this.createdAt,
    this.cancelledAt,
  });

  factory AccountDeletionRequestRow({
    int? id,
    required int profileId,
    _i2.AppProfileRow? profile,
    required String status,
    required DateTime scheduledHardDeleteAt,
    required DateTime createdAt,
    DateTime? cancelledAt,
  }) = _AccountDeletionRequestRowImpl;

  factory AccountDeletionRequestRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountDeletionRequestRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AppProfileRow>(
              jsonSerialization['profile'],
            ),
      status: jsonSerialization['status'] as String,
      scheduledHardDeleteAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledHardDeleteAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
    );
  }

  static final t = AccountDeletionRequestRowTable();

  static const db = AccountDeletionRequestRowRepository._();

  @override
  int? id;

  int profileId;

  _i2.AppProfileRow? profile;

  String status;

  DateTime scheduledHardDeleteAt;

  DateTime createdAt;

  DateTime? cancelledAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountDeletionRequestRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountDeletionRequestRow copyWith({
    int? id,
    int? profileId,
    _i2.AppProfileRow? profile,
    String? status,
    DateTime? scheduledHardDeleteAt,
    DateTime? createdAt,
    DateTime? cancelledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountDeletionRequestRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'status': status,
      'scheduledHardDeleteAt': scheduledHardDeleteAt.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountDeletionRequestRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'status': status,
      'scheduledHardDeleteAt': scheduledHardDeleteAt.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  static AccountDeletionRequestRowInclude include({
    _i2.AppProfileRowInclude? profile,
  }) {
    return AccountDeletionRequestRowInclude._(profile: profile);
  }

  static AccountDeletionRequestRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountDeletionRequestRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountDeletionRequestRowTable>? orderByList,
    AccountDeletionRequestRowInclude? include,
  }) {
    return AccountDeletionRequestRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountDeletionRequestRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountDeletionRequestRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountDeletionRequestRowImpl extends AccountDeletionRequestRow {
  _AccountDeletionRequestRowImpl({
    int? id,
    required int profileId,
    _i2.AppProfileRow? profile,
    required String status,
    required DateTime scheduledHardDeleteAt,
    required DateTime createdAt,
    DateTime? cancelledAt,
  }) : super._(
         id: id,
         profileId: profileId,
         profile: profile,
         status: status,
         scheduledHardDeleteAt: scheduledHardDeleteAt,
         createdAt: createdAt,
         cancelledAt: cancelledAt,
       );

  /// Returns a shallow copy of this [AccountDeletionRequestRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountDeletionRequestRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    String? status,
    DateTime? scheduledHardDeleteAt,
    DateTime? createdAt,
    Object? cancelledAt = _Undefined,
  }) {
    return AccountDeletionRequestRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      profile: profile is _i2.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      status: status ?? this.status,
      scheduledHardDeleteAt:
          scheduledHardDeleteAt ?? this.scheduledHardDeleteAt,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
    );
  }
}

class AccountDeletionRequestRowUpdateTable
    extends _i1.UpdateTable<AccountDeletionRequestRowTable> {
  AccountDeletionRequestRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> profileId(int value) => _i1.ColumnValue(
    table.profileId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledHardDeleteAt(DateTime value) =>
      _i1.ColumnValue(
        table.scheduledHardDeleteAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> cancelledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.cancelledAt,
        value,
      );
}

class AccountDeletionRequestRowTable extends _i1.Table<int?> {
  AccountDeletionRequestRowTable({super.tableRelation})
    : super(tableName: 'account_deletion_request') {
    updateTable = AccountDeletionRequestRowUpdateTable(this);
    profileId = _i1.ColumnInt(
      'profileId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    scheduledHardDeleteAt = _i1.ColumnDateTime(
      'scheduledHardDeleteAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    cancelledAt = _i1.ColumnDateTime(
      'cancelledAt',
      this,
    );
  }

  late final AccountDeletionRequestRowUpdateTable updateTable;

  late final _i1.ColumnInt profileId;

  _i2.AppProfileRowTable? _profile;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime scheduledHardDeleteAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime cancelledAt;

  _i2.AppProfileRowTable get profile {
    if (_profile != null) return _profile!;
    _profile = _i1.createRelationTable(
      relationFieldName: 'profile',
      field: AccountDeletionRequestRow.t.profileId,
      foreignField: _i2.AppProfileRow.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AppProfileRowTable(tableRelation: foreignTableRelation),
    );
    return _profile!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    profileId,
    status,
    scheduledHardDeleteAt,
    createdAt,
    cancelledAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'profile') {
      return profile;
    }
    return null;
  }
}

class AccountDeletionRequestRowInclude extends _i1.IncludeObject {
  AccountDeletionRequestRowInclude._({_i2.AppProfileRowInclude? profile}) {
    _profile = profile;
  }

  _i2.AppProfileRowInclude? _profile;

  @override
  Map<String, _i1.Include?> get includes => {'profile': _profile};

  @override
  _i1.Table<int?> get table => AccountDeletionRequestRow.t;
}

class AccountDeletionRequestRowIncludeList extends _i1.IncludeList {
  AccountDeletionRequestRowIncludeList._({
    _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountDeletionRequestRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountDeletionRequestRow.t;
}

class AccountDeletionRequestRowRepository {
  const AccountDeletionRequestRowRepository._();

  final attachRow = const AccountDeletionRequestRowAttachRowRepository._();

  /// Returns a list of [AccountDeletionRequestRow]s matching the given query parameters.
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
  Future<List<AccountDeletionRequestRow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountDeletionRequestRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountDeletionRequestRowTable>? orderByList,
    _i1.Transaction? transaction,
    AccountDeletionRequestRowInclude? include,
  }) async {
    return session.db.find<AccountDeletionRequestRow>(
      where: where?.call(AccountDeletionRequestRow.t),
      orderBy: orderBy?.call(AccountDeletionRequestRow.t),
      orderByList: orderByList?.call(AccountDeletionRequestRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AccountDeletionRequestRow] matching the given query parameters.
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
  Future<AccountDeletionRequestRow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountDeletionRequestRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountDeletionRequestRowTable>? orderByList,
    _i1.Transaction? transaction,
    AccountDeletionRequestRowInclude? include,
  }) async {
    return session.db.findFirstRow<AccountDeletionRequestRow>(
      where: where?.call(AccountDeletionRequestRow.t),
      orderBy: orderBy?.call(AccountDeletionRequestRow.t),
      orderByList: orderByList?.call(AccountDeletionRequestRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AccountDeletionRequestRow] by its [id] or null if no such row exists.
  Future<AccountDeletionRequestRow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AccountDeletionRequestRowInclude? include,
  }) async {
    return session.db.findById<AccountDeletionRequestRow>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AccountDeletionRequestRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountDeletionRequestRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccountDeletionRequestRow>> insert(
    _i1.Session session,
    List<AccountDeletionRequestRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccountDeletionRequestRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccountDeletionRequestRow] and returns the inserted row.
  ///
  /// The returned [AccountDeletionRequestRow] will have its `id` field set.
  Future<AccountDeletionRequestRow> insertRow(
    _i1.Session session,
    AccountDeletionRequestRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountDeletionRequestRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountDeletionRequestRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountDeletionRequestRow>> update(
    _i1.Session session,
    List<AccountDeletionRequestRow> rows, {
    _i1.ColumnSelections<AccountDeletionRequestRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountDeletionRequestRow>(
      rows,
      columns: columns?.call(AccountDeletionRequestRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountDeletionRequestRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountDeletionRequestRow> updateRow(
    _i1.Session session,
    AccountDeletionRequestRow row, {
    _i1.ColumnSelections<AccountDeletionRequestRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountDeletionRequestRow>(
      row,
      columns: columns?.call(AccountDeletionRequestRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountDeletionRequestRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountDeletionRequestRow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountDeletionRequestRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountDeletionRequestRow>(
      id,
      columnValues: columnValues(AccountDeletionRequestRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountDeletionRequestRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountDeletionRequestRow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AccountDeletionRequestRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountDeletionRequestRowTable>? orderBy,
    _i1.OrderByListBuilder<AccountDeletionRequestRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountDeletionRequestRow>(
      columnValues: columnValues(AccountDeletionRequestRow.t.updateTable),
      where: where(AccountDeletionRequestRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountDeletionRequestRow.t),
      orderByList: orderByList?.call(AccountDeletionRequestRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountDeletionRequestRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountDeletionRequestRow>> delete(
    _i1.Session session,
    List<AccountDeletionRequestRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountDeletionRequestRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountDeletionRequestRow].
  Future<AccountDeletionRequestRow> deleteRow(
    _i1.Session session,
    AccountDeletionRequestRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountDeletionRequestRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountDeletionRequestRow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountDeletionRequestRow>(
      where: where(AccountDeletionRequestRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountDeletionRequestRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountDeletionRequestRow>(
      where: where?.call(AccountDeletionRequestRow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AccountDeletionRequestRowAttachRowRepository {
  const AccountDeletionRequestRowAttachRowRepository._();

  /// Creates a relation between the given [AccountDeletionRequestRow] and [AppProfileRow]
  /// by setting the [AccountDeletionRequestRow]'s foreign key `profileId` to refer to the [AppProfileRow].
  Future<void> profile(
    _i1.Session session,
    AccountDeletionRequestRow accountDeletionRequestRow,
    _i2.AppProfileRow profile, {
    _i1.Transaction? transaction,
  }) async {
    if (accountDeletionRequestRow.id == null) {
      throw ArgumentError.notNull('accountDeletionRequestRow.id');
    }
    if (profile.id == null) {
      throw ArgumentError.notNull('profile.id');
    }

    var $accountDeletionRequestRow = accountDeletionRequestRow.copyWith(
      profileId: profile.id,
    );
    await session.db.updateRow<AccountDeletionRequestRow>(
      $accountDeletionRequestRow,
      columns: [AccountDeletionRequestRow.t.profileId],
      transaction: transaction,
    );
  }
}
