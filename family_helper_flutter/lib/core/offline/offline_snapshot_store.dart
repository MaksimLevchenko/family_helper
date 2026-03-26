class OfflineSnapshot {
  const OfflineSnapshot({
    required this.payload,
    required this.updatedAt,
  });

  final Map<String, dynamic> payload;
  final DateTime updatedAt;
}

abstract class OfflineSnapshotStore {
  Future<void> init();

  Future<OfflineSnapshot?> read(String key);

  Future<void> write(
    String key,
    Map<String, dynamic> payload, {
    DateTime? updatedAt,
  });

  Future<void> delete(String key);

  Future<void> deleteByPrefix(String prefix);

  Future<void> clear();

  Future<void> close();
}
