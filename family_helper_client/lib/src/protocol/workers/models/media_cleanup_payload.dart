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

abstract class MediaCleanupPayload implements _i1.SerializableModel {
  MediaCleanupPayload._({this.runReason});

  factory MediaCleanupPayload({String? runReason}) = _MediaCleanupPayloadImpl;

  factory MediaCleanupPayload.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaCleanupPayload(
      runReason: jsonSerialization['runReason'] as String?,
    );
  }

  String? runReason;

  /// Returns a shallow copy of this [MediaCleanupPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaCleanupPayload copyWith({String? runReason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaCleanupPayload',
      if (runReason != null) 'runReason': runReason,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaCleanupPayloadImpl extends MediaCleanupPayload {
  _MediaCleanupPayloadImpl({String? runReason}) : super._(runReason: runReason);

  /// Returns a shallow copy of this [MediaCleanupPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaCleanupPayload copyWith({Object? runReason = _Undefined}) {
    return MediaCleanupPayload(
      runReason: runReason is String? ? runReason : this.runReason,
    );
  }
}
