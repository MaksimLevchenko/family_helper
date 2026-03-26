import 'offline_snapshot_store.dart';

class InMemoryOfflineSnapshotStore implements OfflineSnapshotStore {
  final Map<String, OfflineSnapshot> _snapshots = {};

  @override
  Future<void> init() async {}

  @override
  Future<OfflineSnapshot?> read(String key) async {
    return _snapshots[key];
  }

  @override
  Future<void> write(
    String key,
    Map<String, dynamic> payload, {
    DateTime? updatedAt,
  }) async {
    _snapshots[key] = OfflineSnapshot(
      payload: payload,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> delete(String key) async {
    _snapshots.remove(key);
  }

  @override
  Future<void> deleteByPrefix(String prefix) async {
    final keys = _snapshots.keys.where((key) => key.startsWith(prefix)).toList();
    for (final key in keys) {
      _snapshots.remove(key);
    }
  }

  @override
  Future<void> clear() async {
    _snapshots.clear();
  }

  @override
  Future<void> close() async {}
}
