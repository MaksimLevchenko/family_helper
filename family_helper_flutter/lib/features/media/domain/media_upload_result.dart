class MediaUploadResult {
  const MediaUploadResult({
    required this.mediaId,
    required this.signedUrl,
  });

  final int mediaId;
  final String signedUrl;
}
