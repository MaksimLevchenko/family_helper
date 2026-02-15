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

abstract class PrivacyExportPayload implements _i1.SerializableModel {
  PrivacyExportPayload._({this.runReason});

  factory PrivacyExportPayload({String? runReason}) = _PrivacyExportPayloadImpl;

  factory PrivacyExportPayload.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PrivacyExportPayload(
      runReason: jsonSerialization['runReason'] as String?,
    );
  }

  String? runReason;

  /// Returns a shallow copy of this [PrivacyExportPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PrivacyExportPayload copyWith({String? runReason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PrivacyExportPayload',
      if (runReason != null) 'runReason': runReason,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PrivacyExportPayloadImpl extends PrivacyExportPayload {
  _PrivacyExportPayloadImpl({String? runReason})
    : super._(runReason: runReason);

  /// Returns a shallow copy of this [PrivacyExportPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PrivacyExportPayload copyWith({Object? runReason = _Undefined}) {
    return PrivacyExportPayload(
      runReason: runReason is String? ? runReason : this.runReason,
    );
  }
}
