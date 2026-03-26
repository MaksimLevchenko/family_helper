import 'package:family_helper_flutter/core/offline/in_memory_offline_snapshot_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('writes and reads snapshots by key', () async {
    final store = InMemoryOfflineSnapshotStore();
    await store.init();
    final updatedAt = DateTime.utc(2026, 3, 26, 10, 30);

    await store.write(
      'tasks/family/7',
      {'items': [1, 2, 3]},
      updatedAt: updatedAt,
    );

    final snapshot = await store.read('tasks/family/7');

    expect(snapshot, isNotNull);
    expect(snapshot!.payload, {'items': [1, 2, 3]});
    expect(snapshot.updatedAt, updatedAt);
  });

  test('replaces existing snapshots and deletes by prefix', () async {
    final store = InMemoryOfflineSnapshotStore();
    await store.init();

    await store.write('profile/current', {'name': 'Alex'});
    await store.write('profile/current', {'name': 'Sam'});
    await store.write('lists/family/1', {'items': []});

    expect((await store.read('profile/current'))!.payload['name'], 'Sam');

    await store.deleteByPrefix('profile/');

    expect(await store.read('profile/current'), isNull);
    expect(await store.read('lists/family/1'), isNotNull);
  });
}
