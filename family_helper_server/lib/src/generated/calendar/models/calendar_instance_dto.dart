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

abstract class CalendarInstanceDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CalendarInstanceDto._({
    required this.eventId,
    required this.occurrenceStart,
    required this.occurrenceEnd,
    required this.title,
    required this.cancelled,
  });

  factory CalendarInstanceDto({
    required int eventId,
    required DateTime occurrenceStart,
    required DateTime occurrenceEnd,
    required String title,
    required bool cancelled,
  }) = _CalendarInstanceDtoImpl;

  factory CalendarInstanceDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarInstanceDto(
      eventId: jsonSerialization['eventId'] as int,
      occurrenceStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceStart'],
      ),
      occurrenceEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceEnd'],
      ),
      title: jsonSerialization['title'] as String,
      cancelled: jsonSerialization['cancelled'] as bool,
    );
  }

  int eventId;

  DateTime occurrenceStart;

  DateTime occurrenceEnd;

  String title;

  bool cancelled;

  /// Returns a shallow copy of this [CalendarInstanceDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarInstanceDto copyWith({
    int? eventId,
    DateTime? occurrenceStart,
    DateTime? occurrenceEnd,
    String? title,
    bool? cancelled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarInstanceDto',
      'eventId': eventId,
      'occurrenceStart': occurrenceStart.toJson(),
      'occurrenceEnd': occurrenceEnd.toJson(),
      'title': title,
      'cancelled': cancelled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarInstanceDto',
      'eventId': eventId,
      'occurrenceStart': occurrenceStart.toJson(),
      'occurrenceEnd': occurrenceEnd.toJson(),
      'title': title,
      'cancelled': cancelled,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CalendarInstanceDtoImpl extends CalendarInstanceDto {
  _CalendarInstanceDtoImpl({
    required int eventId,
    required DateTime occurrenceStart,
    required DateTime occurrenceEnd,
    required String title,
    required bool cancelled,
  }) : super._(
         eventId: eventId,
         occurrenceStart: occurrenceStart,
         occurrenceEnd: occurrenceEnd,
         title: title,
         cancelled: cancelled,
       );

  /// Returns a shallow copy of this [CalendarInstanceDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarInstanceDto copyWith({
    int? eventId,
    DateTime? occurrenceStart,
    DateTime? occurrenceEnd,
    String? title,
    bool? cancelled,
  }) {
    return CalendarInstanceDto(
      eventId: eventId ?? this.eventId,
      occurrenceStart: occurrenceStart ?? this.occurrenceStart,
      occurrenceEnd: occurrenceEnd ?? this.occurrenceEnd,
      title: title ?? this.title,
      cancelled: cancelled ?? this.cancelled,
    );
  }
}
