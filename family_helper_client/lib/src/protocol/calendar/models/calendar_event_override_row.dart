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

abstract class CalendarEventOverrideRow implements _i1.SerializableModel {
  CalendarEventOverrideRow._({
    this.id,
    required this.eventId,
    required this.occurrenceStart,
    this.overrideTitle,
    this.overrideStartsAt,
    this.overrideEndsAt,
    required this.cancelled,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory CalendarEventOverrideRow({
    int? id,
    required int eventId,
    required DateTime occurrenceStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    required bool cancelled,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _CalendarEventOverrideRowImpl;

  factory CalendarEventOverrideRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CalendarEventOverrideRow(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      occurrenceStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceStart'],
      ),
      overrideTitle: jsonSerialization['overrideTitle'] as String?,
      overrideStartsAt: jsonSerialization['overrideStartsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['overrideStartsAt'],
            ),
      overrideEndsAt: jsonSerialization['overrideEndsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['overrideEndsAt'],
            ),
      cancelled: jsonSerialization['cancelled'] as bool,
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

  int eventId;

  DateTime occurrenceStart;

  String? overrideTitle;

  DateTime? overrideStartsAt;

  DateTime? overrideEndsAt;

  bool cancelled;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [CalendarEventOverrideRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarEventOverrideRow copyWith({
    int? id,
    int? eventId,
    DateTime? occurrenceStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    bool? cancelled,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarEventOverrideRow',
      if (id != null) 'id': id,
      'eventId': eventId,
      'occurrenceStart': occurrenceStart.toJson(),
      if (overrideTitle != null) 'overrideTitle': overrideTitle,
      if (overrideStartsAt != null)
        'overrideStartsAt': overrideStartsAt?.toJson(),
      if (overrideEndsAt != null) 'overrideEndsAt': overrideEndsAt?.toJson(),
      'cancelled': cancelled,
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

class _CalendarEventOverrideRowImpl extends CalendarEventOverrideRow {
  _CalendarEventOverrideRowImpl({
    int? id,
    required int eventId,
    required DateTime occurrenceStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    required bool cancelled,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         eventId: eventId,
         occurrenceStart: occurrenceStart,
         overrideTitle: overrideTitle,
         overrideStartsAt: overrideStartsAt,
         overrideEndsAt: overrideEndsAt,
         cancelled: cancelled,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CalendarEventOverrideRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarEventOverrideRow copyWith({
    Object? id = _Undefined,
    int? eventId,
    DateTime? occurrenceStart,
    Object? overrideTitle = _Undefined,
    Object? overrideStartsAt = _Undefined,
    Object? overrideEndsAt = _Undefined,
    bool? cancelled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return CalendarEventOverrideRow(
      id: id is int? ? id : this.id,
      eventId: eventId ?? this.eventId,
      occurrenceStart: occurrenceStart ?? this.occurrenceStart,
      overrideTitle: overrideTitle is String?
          ? overrideTitle
          : this.overrideTitle,
      overrideStartsAt: overrideStartsAt is DateTime?
          ? overrideStartsAt
          : this.overrideStartsAt,
      overrideEndsAt: overrideEndsAt is DateTime?
          ? overrideEndsAt
          : this.overrideEndsAt,
      cancelled: cancelled ?? this.cancelled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
