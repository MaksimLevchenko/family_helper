import 'package:dio/dio.dart';
import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/network/app_api_client.dart';
import '../../../core/network/server_url_resolver.dart';
import '../../../core/utils/operation_id.dart';

class MediaRepository {
  MediaRepository(this._apiClient) : _dio = Dio();

  final AppApiClient _apiClient;
  final Dio _dio;
  final ImagePicker _picker = ImagePicker();

  Future<MediaObjectDto?> pickCropUpload({int? familyId}) async {
    final selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected == null) {
      return null;
    }

    final bytes = await _readUploadBytes(selected);
    final sizeBytes = bytes.length;
    final mimeType = _resolveMimeType(selected);

    final uploadSession = await _apiClient.client.media.createUploadSession(
      clientOperationId: OperationId.next(),
      familyId: familyId,
      mimeType: mimeType,
      sizeBytes: sizeBytes,
      objectPrefix: familyId == null ? 'avatars' : 'attachments',
    );
    final normalizedUploadUrl = ServerUrlResolver.normalizeAgainstBase(
      uploadSession.uploadUrl,
      baseUrl: _apiClient.client.host,
      platform: defaultTargetPlatform,
    );

    try {
      final response = await _dio.post<dynamic>(
        normalizedUploadUrl,
        data: bytes,
        options: Options(
          headers: {'Content-Type': 'application/octet-stream'},
          responseType: ResponseType.plain,
        ),
      );
      final responseBody = response.data?.toString().trim().toLowerCase();
      if (response.statusCode != 200 || responseBody != 'true') {
        throw Exception('Upload endpoint rejected the binary payload.');
      }
    } catch (error, stackTrace) {
      final uploadUri = Uri.tryParse(normalizedUploadUrl);
      AppErrorLogger.logHandled(
        scope: 'media.putUpload',
        error: error,
        stackTrace: stackTrace,
        context: {
          'uploadHost': uploadUri?.host,
          'uploadScheme': uploadUri?.scheme,
          'appOrigin': kIsWeb ? Uri.base.origin : 'non-web',
        },
      );

      if (kIsWeb && error is DioException) {
        throw Exception(
          'Web upload failed at network layer. '
          'Check that storage URL is reachable from browser and CORS allows '
          'POST/OPTIONS from ${Uri.base.origin}. '
          'uploadHost=${uploadUri?.host ?? 'unknown'}',
        );
      }

      rethrow;
    }

    final media = await _apiClient.client.media.completeUpload(
      clientOperationId: OperationId.next(),
      mediaId: uploadSession.mediaId,
    );

    return media;
  }

  Future<String> signedGetUrl(int mediaId) async {
    final signedUrl = await _apiClient.client.media.signedGetUrl(
      mediaId: mediaId,
    );
    return ServerUrlResolver.normalizeAgainstBase(
      signedUrl,
      baseUrl: _apiClient.client.host,
      platform: defaultTargetPlatform,
    );
  }

  Future<List<MediaObjectDto>> listMedia({int? familyId, int limit = 100}) {
    return _apiClient.client.media.listMedia(familyId: familyId, limit: limit);
  }

  Future<OperationResult> softDelete({
    required String clientOperationId,
    required int mediaId,
  }) {
    return _apiClient.client.media.softDelete(
      clientOperationId: clientOperationId,
      mediaId: mediaId,
    );
  }

  Future<List<int>> _readUploadBytes(XFile selected) async {
    // image_cropper is unstable on web for blob/file paths; use original bytes.
    if (kIsWeb) {
      return selected.readAsBytes();
    }

    try {
      final cropped = await ImageCropper().cropImage(sourcePath: selected.path);
      if (cropped != null) {
        return cropped.readAsBytes();
      }
    } catch (_) {
      // Fallback to original image if crop operation fails.
    }

    return selected.readAsBytes();
  }

  String _resolveMimeType(XFile file) {
    final mimeType = file.mimeType?.toLowerCase();
    if (mimeType != null && mimeType.startsWith('image/')) {
      return mimeType;
    }

    final path = file.path.toLowerCase();
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.webp')) return 'image/webp';
    if (path.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }
}
