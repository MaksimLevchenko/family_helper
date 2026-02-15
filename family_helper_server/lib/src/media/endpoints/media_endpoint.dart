import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/media_service.dart';

class MediaEndpoint extends Endpoint {
  MediaEndpoint({MediaService? service}) : service = service ?? MediaService();

  final MediaService service;

  Future<UploadSessionDto> createUploadSession(
    Session session, {
    required String clientOperationId,
    int? familyId,
    required String mimeType,
    required int sizeBytes,
    String objectPrefix = 'media',
  }) {
    return service.createUploadSession(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      mimeType: mimeType,
      sizeBytes: sizeBytes,
      objectPrefix: objectPrefix,
    );
  }

  Future<MediaObjectDto> completeUpload(
    Session session, {
    required String clientOperationId,
    required int mediaId,
    String? thumbnailKey,
  }) {
    return service.completeUpload(
      session,
      clientOperationId: clientOperationId,
      mediaId: mediaId,
      thumbnailKey: thumbnailKey,
    );
  }

  Future<String> signedGetUrl(
    Session session, {
    required int mediaId,
  }) {
    return service.signedGetUrl(session, mediaId: mediaId);
  }

  Future<OperationResult> softDelete(
    Session session, {
    required String clientOperationId,
    required int mediaId,
  }) {
    return service.softDelete(
      session,
      clientOperationId: clientOperationId,
      mediaId: mediaId,
    );
  }
}
