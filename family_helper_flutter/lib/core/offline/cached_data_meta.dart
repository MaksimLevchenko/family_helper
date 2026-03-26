class CachedDataMeta {
  const CachedDataMeta({
    required this.isUsingCachedData,
    this.lastSuccessfulSyncAt,
  });

  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
}
