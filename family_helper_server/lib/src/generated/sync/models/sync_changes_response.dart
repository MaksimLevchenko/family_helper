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
import '../../sync/models/sync_change_dto.dart' as _i2;
import 'package:family_helper_server/src/generated/protocol.dart' as _i3;

abstract class SyncChangesResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SyncChangesResponse._({
    required this.since,
    required this.nextSince,
    required this.nextLastSeenChangeId,
    required this.hasMore,
    required this.changes,
  });

  factory SyncChangesResponse({
    required DateTime since,
    required DateTime nextSince,
    required int nextLastSeenChangeId,
    required bool hasMore,
    required List<_i2.SyncChangeDto> changes,
  }) = _SyncChangesResponseImpl;

  factory SyncChangesResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncChangesResponse(
      since: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['since']),
      nextSince: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['nextSince'],
      ),
      nextLastSeenChangeId: jsonSerialization['nextLastSeenChangeId'] as int,
      hasMore: jsonSerialization['hasMore'] as bool,
      changes: _i3.Protocol().deserialize<List<_i2.SyncChangeDto>>(
        jsonSerialization['changes'],
      ),
    );
  }

  DateTime since;

  DateTime nextSince;

  int nextLastSeenChangeId;

  bool hasMore;

  List<_i2.SyncChangeDto> changes;

  /// Returns a shallow copy of this [SyncChangesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SyncChangesResponse copyWith({
    DateTime? since,
    DateTime? nextSince,
    int? nextLastSeenChangeId,
    bool? hasMore,
    List<_i2.SyncChangeDto>? changes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncChangesResponse',
      'since': since.toJson(),
      'nextSince': nextSince.toJson(),
      'nextLastSeenChangeId': nextLastSeenChangeId,
      'hasMore': hasMore,
      'changes': changes.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncChangesResponse',
      'since': since.toJson(),
      'nextSince': nextSince.toJson(),
      'nextLastSeenChangeId': nextLastSeenChangeId,
      'hasMore': hasMore,
      'changes': changes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SyncChangesResponseImpl extends SyncChangesResponse {
  _SyncChangesResponseImpl({
    required DateTime since,
    required DateTime nextSince,
    required int nextLastSeenChangeId,
    required bool hasMore,
    required List<_i2.SyncChangeDto> changes,
  }) : super._(
         since: since,
         nextSince: nextSince,
         nextLastSeenChangeId: nextLastSeenChangeId,
         hasMore: hasMore,
         changes: changes,
       );

  /// Returns a shallow copy of this [SyncChangesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SyncChangesResponse copyWith({
    DateTime? since,
    DateTime? nextSince,
    int? nextLastSeenChangeId,
    bool? hasMore,
    List<_i2.SyncChangeDto>? changes,
  }) {
    return SyncChangesResponse(
      since: since ?? this.since,
      nextSince: nextSince ?? this.nextSince,
      nextLastSeenChangeId: nextLastSeenChangeId ?? this.nextLastSeenChangeId,
      hasMore: hasMore ?? this.hasMore,
      changes: changes ?? this.changes.map((e0) => e0.copyWith()).toList(),
    );
  }
}
