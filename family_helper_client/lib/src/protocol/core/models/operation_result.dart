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

abstract class OperationResult implements _i1.SerializableModel {
  OperationResult._({
    required this.success,
    required this.message,
  });

  factory OperationResult({
    required bool success,
    required String message,
  }) = _OperationResultImpl;

  factory OperationResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return OperationResult(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String,
    );
  }

  bool success;

  String message;

  /// Returns a shallow copy of this [OperationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OperationResult copyWith({
    bool? success,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OperationResult',
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _OperationResultImpl extends OperationResult {
  _OperationResultImpl({
    required bool success,
    required String message,
  }) : super._(
         success: success,
         message: message,
       );

  /// Returns a shallow copy of this [OperationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OperationResult copyWith({
    bool? success,
    String? message,
  }) {
    return OperationResult(
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }
}
