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
import '../../privacy/models/privacy_export_job_dto.dart' as _i2;
import '../../privacy/models/account_deletion_status_dto.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class PrivacyStatusDto implements _i1.SerializableModel {
  PrivacyStatusDto._({
    this.lastExportJob,
    this.accountDeletion,
  });

  factory PrivacyStatusDto({
    _i2.PrivacyExportJobDto? lastExportJob,
    _i3.AccountDeletionStatusDto? accountDeletion,
  }) = _PrivacyStatusDtoImpl;

  factory PrivacyStatusDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return PrivacyStatusDto(
      lastExportJob: jsonSerialization['lastExportJob'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.PrivacyExportJobDto>(
              jsonSerialization['lastExportJob'],
            ),
      accountDeletion: jsonSerialization['accountDeletion'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AccountDeletionStatusDto>(
              jsonSerialization['accountDeletion'],
            ),
    );
  }

  _i2.PrivacyExportJobDto? lastExportJob;

  _i3.AccountDeletionStatusDto? accountDeletion;

  /// Returns a shallow copy of this [PrivacyStatusDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PrivacyStatusDto copyWith({
    _i2.PrivacyExportJobDto? lastExportJob,
    _i3.AccountDeletionStatusDto? accountDeletion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PrivacyStatusDto',
      if (lastExportJob != null) 'lastExportJob': lastExportJob?.toJson(),
      if (accountDeletion != null) 'accountDeletion': accountDeletion?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PrivacyStatusDtoImpl extends PrivacyStatusDto {
  _PrivacyStatusDtoImpl({
    _i2.PrivacyExportJobDto? lastExportJob,
    _i3.AccountDeletionStatusDto? accountDeletion,
  }) : super._(
         lastExportJob: lastExportJob,
         accountDeletion: accountDeletion,
       );

  /// Returns a shallow copy of this [PrivacyStatusDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PrivacyStatusDto copyWith({
    Object? lastExportJob = _Undefined,
    Object? accountDeletion = _Undefined,
  }) {
    return PrivacyStatusDto(
      lastExportJob: lastExportJob is _i2.PrivacyExportJobDto?
          ? lastExportJob
          : this.lastExportJob?.copyWith(),
      accountDeletion: accountDeletion is _i3.AccountDeletionStatusDto?
          ? accountDeletion
          : this.accountDeletion?.copyWith(),
    );
  }
}
