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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../lists/models/family_list_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class ListItemRow implements _i1.SerializableModel {
  ListItemRow._({
    this.id,
    required this.listId,
    this.list,
    required this.title,
    required this.qty,
    this.unit,
    this.note,
    this.priceCents,
    this.category,
    required this.positionIndex,
    required this.isBought,
    this.boughtByProfileId,
    this.boughtByProfile,
    this.boughtAt,
    required this.createdByProfileId,
    this.createdByProfile,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory ListItemRow({
    int? id,
    required int listId,
    _i2.FamilyListRow? list,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    required int positionIndex,
    required bool isBought,
    int? boughtByProfileId,
    _i3.AppProfileRow? boughtByProfile,
    DateTime? boughtAt,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _ListItemRowImpl;

  factory ListItemRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListItemRow(
      id: jsonSerialization['id'] as int?,
      listId: jsonSerialization['listId'] as int,
      list: jsonSerialization['list'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FamilyListRow>(
              jsonSerialization['list'],
            ),
      title: jsonSerialization['title'] as String,
      qty: (jsonSerialization['qty'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String?,
      note: jsonSerialization['note'] as String?,
      priceCents: jsonSerialization['priceCents'] as int?,
      category: jsonSerialization['category'] as String?,
      positionIndex: jsonSerialization['positionIndex'] as int,
      isBought: jsonSerialization['isBought'] as bool,
      boughtByProfileId: jsonSerialization['boughtByProfileId'] as int?,
      boughtByProfile: jsonSerialization['boughtByProfile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['boughtByProfile'],
            ),
      boughtAt: jsonSerialization['boughtAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['boughtAt']),
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int listId;

  _i2.FamilyListRow? list;

  String title;

  double qty;

  String? unit;

  String? note;

  int? priceCents;

  String? category;

  int positionIndex;

  bool isBought;

  int? boughtByProfileId;

  _i3.AppProfileRow? boughtByProfile;

  DateTime? boughtAt;

  int createdByProfileId;

  _i3.AppProfileRow? createdByProfile;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [ListItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ListItemRow copyWith({
    int? id,
    int? listId,
    _i2.FamilyListRow? list,
    String? title,
    double? qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    int? positionIndex,
    bool? isBought,
    int? boughtByProfileId,
    _i3.AppProfileRow? boughtByProfile,
    DateTime? boughtAt,
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
      '__className__': 'ListItemRow',
      if (id != null) 'id': id,
      'listId': listId,
      if (list != null) 'list': list?.toJson(),
      'title': title,
      'qty': qty,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (priceCents != null) 'priceCents': priceCents,
      if (category != null) 'category': category,
      'positionIndex': positionIndex,
      'isBought': isBought,
      if (boughtByProfileId != null) 'boughtByProfileId': boughtByProfileId,
      if (boughtByProfile != null) 'boughtByProfile': boughtByProfile?.toJson(),
      if (boughtAt != null) 'boughtAt': boughtAt?.toJson(),
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListItemRowImpl extends ListItemRow {
  _ListItemRowImpl({
    int? id,
    required int listId,
    _i2.FamilyListRow? list,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    required int positionIndex,
    required bool isBought,
    int? boughtByProfileId,
    _i3.AppProfileRow? boughtByProfile,
    DateTime? boughtAt,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         listId: listId,
         list: list,
         title: title,
         qty: qty,
         unit: unit,
         note: note,
         priceCents: priceCents,
         category: category,
         positionIndex: positionIndex,
         isBought: isBought,
         boughtByProfileId: boughtByProfileId,
         boughtByProfile: boughtByProfile,
         boughtAt: boughtAt,
         createdByProfileId: createdByProfileId,
         createdByProfile: createdByProfile,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ListItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ListItemRow copyWith({
    Object? id = _Undefined,
    int? listId,
    Object? list = _Undefined,
    String? title,
    double? qty,
    Object? unit = _Undefined,
    Object? note = _Undefined,
    Object? priceCents = _Undefined,
    Object? category = _Undefined,
    int? positionIndex,
    bool? isBought,
    Object? boughtByProfileId = _Undefined,
    Object? boughtByProfile = _Undefined,
    Object? boughtAt = _Undefined,
    int? createdByProfileId,
    Object? createdByProfile = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return ListItemRow(
      id: id is int? ? id : this.id,
      listId: listId ?? this.listId,
      list: list is _i2.FamilyListRow? ? list : this.list?.copyWith(),
      title: title ?? this.title,
      qty: qty ?? this.qty,
      unit: unit is String? ? unit : this.unit,
      note: note is String? ? note : this.note,
      priceCents: priceCents is int? ? priceCents : this.priceCents,
      category: category is String? ? category : this.category,
      positionIndex: positionIndex ?? this.positionIndex,
      isBought: isBought ?? this.isBought,
      boughtByProfileId: boughtByProfileId is int?
          ? boughtByProfileId
          : this.boughtByProfileId,
      boughtByProfile: boughtByProfile is _i3.AppProfileRow?
          ? boughtByProfile
          : this.boughtByProfile?.copyWith(),
      boughtAt: boughtAt is DateTime? ? boughtAt : this.boughtAt,
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
