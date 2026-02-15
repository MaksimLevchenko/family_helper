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

abstract class PagedRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PagedRequest._({
    required this.limit,
    required this.offset,
  });

  factory PagedRequest({
    required int limit,
    required int offset,
  }) = _PagedRequestImpl;

  factory PagedRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PagedRequest(
      limit: jsonSerialization['limit'] as int,
      offset: jsonSerialization['offset'] as int,
    );
  }

  int limit;

  int offset;

  /// Returns a shallow copy of this [PagedRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PagedRequest copyWith({
    int? limit,
    int? offset,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PagedRequest',
      'limit': limit,
      'offset': offset,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PagedRequest',
      'limit': limit,
      'offset': offset,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PagedRequestImpl extends PagedRequest {
  _PagedRequestImpl({
    required int limit,
    required int offset,
  }) : super._(
         limit: limit,
         offset: offset,
       );

  /// Returns a shallow copy of this [PagedRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PagedRequest copyWith({
    int? limit,
    int? offset,
  }) {
    return PagedRequest(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}
