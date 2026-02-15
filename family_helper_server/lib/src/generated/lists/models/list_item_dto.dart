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

abstract class ListItemDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ListItemDto._({
    required this.id,
    required this.listId,
    required this.title,
    required this.qty,
    this.unit,
    this.note,
    this.priceCents,
    this.category,
    required this.positionIndex,
    required this.isBought,
    this.boughtByProfileId,
    this.boughtAt,
    required this.updatedAt,
    required this.version,
  });

  factory ListItemDto({
    required int id,
    required int listId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    required int positionIndex,
    required bool isBought,
    int? boughtByProfileId,
    DateTime? boughtAt,
    required DateTime updatedAt,
    required int version,
  }) = _ListItemDtoImpl;

  factory ListItemDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListItemDto(
      id: jsonSerialization['id'] as int,
      listId: jsonSerialization['listId'] as int,
      title: jsonSerialization['title'] as String,
      qty: (jsonSerialization['qty'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String?,
      note: jsonSerialization['note'] as String?,
      priceCents: jsonSerialization['priceCents'] as int?,
      category: jsonSerialization['category'] as String?,
      positionIndex: jsonSerialization['positionIndex'] as int,
      isBought: jsonSerialization['isBought'] as bool,
      boughtByProfileId: jsonSerialization['boughtByProfileId'] as int?,
      boughtAt: jsonSerialization['boughtAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['boughtAt']),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  int id;

  int listId;

  String title;

  double qty;

  String? unit;

  String? note;

  int? priceCents;

  String? category;

  int positionIndex;

  bool isBought;

  int? boughtByProfileId;

  DateTime? boughtAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [ListItemDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ListItemDto copyWith({
    int? id,
    int? listId,
    String? title,
    double? qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    int? positionIndex,
    bool? isBought,
    int? boughtByProfileId,
    DateTime? boughtAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ListItemDto',
      'id': id,
      'listId': listId,
      'title': title,
      'qty': qty,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (priceCents != null) 'priceCents': priceCents,
      if (category != null) 'category': category,
      'positionIndex': positionIndex,
      'isBought': isBought,
      if (boughtByProfileId != null) 'boughtByProfileId': boughtByProfileId,
      if (boughtAt != null) 'boughtAt': boughtAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ListItemDto',
      'id': id,
      'listId': listId,
      'title': title,
      'qty': qty,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (priceCents != null) 'priceCents': priceCents,
      if (category != null) 'category': category,
      'positionIndex': positionIndex,
      'isBought': isBought,
      if (boughtByProfileId != null) 'boughtByProfileId': boughtByProfileId,
      if (boughtAt != null) 'boughtAt': boughtAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListItemDtoImpl extends ListItemDto {
  _ListItemDtoImpl({
    required int id,
    required int listId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
    required int positionIndex,
    required bool isBought,
    int? boughtByProfileId,
    DateTime? boughtAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         listId: listId,
         title: title,
         qty: qty,
         unit: unit,
         note: note,
         priceCents: priceCents,
         category: category,
         positionIndex: positionIndex,
         isBought: isBought,
         boughtByProfileId: boughtByProfileId,
         boughtAt: boughtAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ListItemDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ListItemDto copyWith({
    int? id,
    int? listId,
    String? title,
    double? qty,
    Object? unit = _Undefined,
    Object? note = _Undefined,
    Object? priceCents = _Undefined,
    Object? category = _Undefined,
    int? positionIndex,
    bool? isBought,
    Object? boughtByProfileId = _Undefined,
    Object? boughtAt = _Undefined,
    DateTime? updatedAt,
    int? version,
  }) {
    return ListItemDto(
      id: id ?? this.id,
      listId: listId ?? this.listId,
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
      boughtAt: boughtAt is DateTime? ? boughtAt : this.boughtAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
