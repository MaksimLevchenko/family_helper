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

abstract class MutationMeta implements _i1.SerializableModel {
  MutationMeta._({required this.clientOperationId});

  factory MutationMeta({required String clientOperationId}) = _MutationMetaImpl;

  factory MutationMeta.fromJson(Map<String, dynamic> jsonSerialization) {
    return MutationMeta(
      clientOperationId: jsonSerialization['clientOperationId'] as String,
    );
  }

  String clientOperationId;

  /// Returns a shallow copy of this [MutationMeta]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MutationMeta copyWith({String? clientOperationId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MutationMeta',
      'clientOperationId': clientOperationId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MutationMetaImpl extends MutationMeta {
  _MutationMetaImpl({required String clientOperationId})
    : super._(clientOperationId: clientOperationId);

  /// Returns a shallow copy of this [MutationMeta]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MutationMeta copyWith({String? clientOperationId}) {
    return MutationMeta(
      clientOperationId: clientOperationId ?? this.clientOperationId,
    );
  }
}
