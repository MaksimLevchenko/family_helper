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

abstract class CalendarEventDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CalendarEventDto._({
    required this.id,
    required this.familyId,
    required this.title,
    this.description,
    required this.timezone,
    required this.startsAt,
    required this.endsAt,
    this.rrule,
    this.colorKey,
    this.category,
    required this.createdByProfileId,
    required this.updatedAt,
    required this.version,
  });

  factory CalendarEventDto({
    required int id,
    required int familyId,
    required String title,
    String? description,
    required String timezone,
    required DateTime startsAt,
    required DateTime endsAt,
    String? rrule,
    String? colorKey,
    String? category,
    required int createdByProfileId,
    required DateTime updatedAt,
    required int version,
  }) = _CalendarEventDtoImpl;

  factory CalendarEventDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarEventDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      timezone: jsonSerialization['timezone'] as String,
      startsAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startsAt'],
      ),
      endsAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
      rrule: jsonSerialization['rrule'] as String?,
      colorKey: jsonSerialization['colorKey'] as String?,
      category: jsonSerialization['category'] as String?,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  int id;

  int familyId;

  String title;

  String? description;

  String timezone;

  DateTime startsAt;

  DateTime endsAt;

  String? rrule;

  String? colorKey;

  String? category;

  int createdByProfileId;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [CalendarEventDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarEventDto copyWith({
    int? id,
    int? familyId,
    String? title,
    String? description,
    String? timezone,
    DateTime? startsAt,
    DateTime? endsAt,
    String? rrule,
    String? colorKey,
    String? category,
    int? createdByProfileId,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarEventDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'timezone': timezone,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      if (rrule != null) 'rrule': rrule,
      if (colorKey != null) 'colorKey': colorKey,
      if (category != null) 'category': category,
      'createdByProfileId': createdByProfileId,
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarEventDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'timezone': timezone,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      if (rrule != null) 'rrule': rrule,
      if (colorKey != null) 'colorKey': colorKey,
      if (category != null) 'category': category,
      'createdByProfileId': createdByProfileId,
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

class _CalendarEventDtoImpl extends CalendarEventDto {
  _CalendarEventDtoImpl({
    required int id,
    required int familyId,
    required String title,
    String? description,
    required String timezone,
    required DateTime startsAt,
    required DateTime endsAt,
    String? rrule,
    String? colorKey,
    String? category,
    required int createdByProfileId,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         description: description,
         timezone: timezone,
         startsAt: startsAt,
         endsAt: endsAt,
         rrule: rrule,
         colorKey: colorKey,
         category: category,
         createdByProfileId: createdByProfileId,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CalendarEventDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarEventDto copyWith({
    int? id,
    int? familyId,
    String? title,
    Object? description = _Undefined,
    String? timezone,
    DateTime? startsAt,
    DateTime? endsAt,
    Object? rrule = _Undefined,
    Object? colorKey = _Undefined,
    Object? category = _Undefined,
    int? createdByProfileId,
    DateTime? updatedAt,
    int? version,
  }) {
    return CalendarEventDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      timezone: timezone ?? this.timezone,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      rrule: rrule is String? ? rrule : this.rrule,
      colorKey: colorKey is String? ? colorKey : this.colorKey,
      category: category is String? ? category : this.category,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
