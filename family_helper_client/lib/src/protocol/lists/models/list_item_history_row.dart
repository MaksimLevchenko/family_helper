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
import '../../lists/models/list_item_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class ListItemHistoryRow implements _i1.SerializableModel {
  ListItemHistoryRow._({
    this.id,
    required this.itemId,
    this.item,
    required this.actorProfileId,
    this.actorProfile,
    required this.eventType,
    required this.createdAt,
  });

  factory ListItemHistoryRow({
    int? id,
    required int itemId,
    _i2.ListItemRow? item,
    required int actorProfileId,
    _i3.AppProfileRow? actorProfile,
    required String eventType,
    required DateTime createdAt,
  }) = _ListItemHistoryRowImpl;

  factory ListItemHistoryRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListItemHistoryRow(
      id: jsonSerialization['id'] as int?,
      itemId: jsonSerialization['itemId'] as int,
      item: jsonSerialization['item'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.ListItemRow>(
              jsonSerialization['item'],
            ),
      actorProfileId: jsonSerialization['actorProfileId'] as int,
      actorProfile: jsonSerialization['actorProfile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['actorProfile'],
            ),
      eventType: jsonSerialization['eventType'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int itemId;

  _i2.ListItemRow? item;

  int actorProfileId;

  _i3.AppProfileRow? actorProfile;

  String eventType;

  DateTime createdAt;

  /// Returns a shallow copy of this [ListItemHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ListItemHistoryRow copyWith({
    int? id,
    int? itemId,
    _i2.ListItemRow? item,
    int? actorProfileId,
    _i3.AppProfileRow? actorProfile,
    String? eventType,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ListItemHistoryRow',
      if (id != null) 'id': id,
      'itemId': itemId,
      if (item != null) 'item': item?.toJson(),
      'actorProfileId': actorProfileId,
      if (actorProfile != null) 'actorProfile': actorProfile?.toJson(),
      'eventType': eventType,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListItemHistoryRowImpl extends ListItemHistoryRow {
  _ListItemHistoryRowImpl({
    int? id,
    required int itemId,
    _i2.ListItemRow? item,
    required int actorProfileId,
    _i3.AppProfileRow? actorProfile,
    required String eventType,
    required DateTime createdAt,
  }) : super._(
         id: id,
         itemId: itemId,
         item: item,
         actorProfileId: actorProfileId,
         actorProfile: actorProfile,
         eventType: eventType,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ListItemHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ListItemHistoryRow copyWith({
    Object? id = _Undefined,
    int? itemId,
    Object? item = _Undefined,
    int? actorProfileId,
    Object? actorProfile = _Undefined,
    String? eventType,
    DateTime? createdAt,
  }) {
    return ListItemHistoryRow(
      id: id is int? ? id : this.id,
      itemId: itemId ?? this.itemId,
      item: item is _i2.ListItemRow? ? item : this.item?.copyWith(),
      actorProfileId: actorProfileId ?? this.actorProfileId,
      actorProfile: actorProfile is _i3.AppProfileRow?
          ? actorProfile
          : this.actorProfile?.copyWith(),
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
