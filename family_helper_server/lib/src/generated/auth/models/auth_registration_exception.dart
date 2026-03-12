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
import '../../auth/models/auth_registration_exception_reason.dart' as _i2;

/// Exception to be thrown if app-specific registration fails before the
/// standard Serverpod email flow can proceed.
abstract class AuthRegistrationException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  AuthRegistrationException._({required this.reason});

  factory AuthRegistrationException({
    required _i2.AuthRegistrationExceptionReason reason,
  }) = _AuthRegistrationExceptionImpl;

  factory AuthRegistrationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AuthRegistrationException(
      reason: _i2.AuthRegistrationExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i2.AuthRegistrationExceptionReason reason;

  /// Returns a shallow copy of this [AuthRegistrationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthRegistrationException copyWith({
    _i2.AuthRegistrationExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthRegistrationException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthRegistrationException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthRegistrationException(reason: $reason)';
  }
}

class _AuthRegistrationExceptionImpl extends AuthRegistrationException {
  _AuthRegistrationExceptionImpl({
    required _i2.AuthRegistrationExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [AuthRegistrationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthRegistrationException copyWith({
    _i2.AuthRegistrationExceptionReason? reason,
  }) {
    return AuthRegistrationException(reason: reason ?? this.reason);
  }
}
