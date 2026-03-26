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

abstract class CalendarInstanceDto implements _i1.SerializableModel {
  CalendarInstanceDto._({
    required this.eventId,
    required this.occurrenceKeyStart,
    required this.occurrenceStart,
    required this.occurrenceEnd,
    required this.title,
    required this.cancelled,
    required this.isRecurring,
    required this.isException,
    this.reminderOffsetMinutes,
  });

  factory CalendarInstanceDto({
    required int eventId,
    required DateTime occurrenceKeyStart,
    required DateTime occurrenceStart,
    required DateTime occurrenceEnd,
    required String title,
    required bool cancelled,
    required bool isRecurring,
    required bool isException,
    int? reminderOffsetMinutes,
  }) = _CalendarInstanceDtoImpl;

  factory CalendarInstanceDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarInstanceDto(
      eventId: jsonSerialization['eventId'] as int,
      occurrenceKeyStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceKeyStart'],
      ),
      occurrenceStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceStart'],
      ),
      occurrenceEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceEnd'],
      ),
      title: jsonSerialization['title'] as String,
      cancelled: jsonSerialization['cancelled'] as bool,
      isRecurring: jsonSerialization['isRecurring'] as bool,
      isException: jsonSerialization['isException'] as bool,
      reminderOffsetMinutes: jsonSerialization['reminderOffsetMinutes'] as int?,
    );
  }

  int eventId;

  DateTime occurrenceKeyStart;

  DateTime occurrenceStart;

  DateTime occurrenceEnd;

  String title;

  bool cancelled;

  bool isRecurring;

  bool isException;

  int? reminderOffsetMinutes;

  /// Returns a shallow copy of this [CalendarInstanceDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarInstanceDto copyWith({
    int? eventId,
    DateTime? occurrenceKeyStart,
    DateTime? occurrenceStart,
    DateTime? occurrenceEnd,
    String? title,
    bool? cancelled,
    bool? isRecurring,
    bool? isException,
    int? reminderOffsetMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarInstanceDto',
      'eventId': eventId,
      'occurrenceKeyStart': occurrenceKeyStart.toJson(),
      'occurrenceStart': occurrenceStart.toJson(),
      'occurrenceEnd': occurrenceEnd.toJson(),
      'title': title,
      'cancelled': cancelled,
      'isRecurring': isRecurring,
      'isException': isException,
      if (reminderOffsetMinutes != null)
        'reminderOffsetMinutes': reminderOffsetMinutes,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarInstanceDtoImpl extends CalendarInstanceDto {
  _CalendarInstanceDtoImpl({
    required int eventId,
    required DateTime occurrenceKeyStart,
    required DateTime occurrenceStart,
    required DateTime occurrenceEnd,
    required String title,
    required bool cancelled,
    required bool isRecurring,
    required bool isException,
    int? reminderOffsetMinutes,
  }) : super._(
         eventId: eventId,
         occurrenceKeyStart: occurrenceKeyStart,
         occurrenceStart: occurrenceStart,
         occurrenceEnd: occurrenceEnd,
         title: title,
         cancelled: cancelled,
         isRecurring: isRecurring,
         isException: isException,
         reminderOffsetMinutes: reminderOffsetMinutes,
       );

  /// Returns a shallow copy of this [CalendarInstanceDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarInstanceDto copyWith({
    int? eventId,
    DateTime? occurrenceKeyStart,
    DateTime? occurrenceStart,
    DateTime? occurrenceEnd,
    String? title,
    bool? cancelled,
    bool? isRecurring,
    bool? isException,
    Object? reminderOffsetMinutes = _Undefined,
  }) {
    return CalendarInstanceDto(
      eventId: eventId ?? this.eventId,
      occurrenceKeyStart: occurrenceKeyStart ?? this.occurrenceKeyStart,
      occurrenceStart: occurrenceStart ?? this.occurrenceStart,
      occurrenceEnd: occurrenceEnd ?? this.occurrenceEnd,
      title: title ?? this.title,
      cancelled: cancelled ?? this.cancelled,
      isRecurring: isRecurring ?? this.isRecurring,
      isException: isException ?? this.isException,
      reminderOffsetMinutes: reminderOffsetMinutes is int?
          ? reminderOffsetMinutes
          : this.reminderOffsetMinutes,
    );
  }
}
