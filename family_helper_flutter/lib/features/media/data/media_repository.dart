import 'dart:io';

import 'package:dio/dio.dart';
import 'package:family_helper_client/family_helper_client.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/app_api_client.dart';
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

    final cropped = await ImageCropper().cropImage(sourcePath: selected.path);
    final path = cropped?.path ?? selected.path;
    final file = File(path);
    final sizeBytes = await file.length();

    final uploadSession = await _apiClient.client.media.createUploadSession(
      clientOperationId: OperationId.next(),
      familyId: familyId,
      mimeType: 'image/jpeg',
      sizeBytes: sizeBytes,
      objectPrefix: familyId == null ? 'avatars' : 'attachments',
    );

    await _dio.put(
      uploadSession.uploadUrl,
      data: await file.readAsBytes(),
      options: Options(
        headers: {'Content-Type': 'image/jpeg'},
      ),
    );

    final media = await _apiClient.client.media.completeUpload(
      clientOperationId: OperationId.next(),
      mediaId: uploadSession.mediaId,
    );

    return media;
  }

  Future<String> signedGetUrl(int mediaId) {
    return _apiClient.client.media.signedGetUrl(mediaId: mediaId);
  }
}
