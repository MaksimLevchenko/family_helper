import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/core/offline/offline_operation.dart';
import 'package:family_helper_flutter/core/offline/offline_operation_queue.dart';
import 'package:family_helper_flutter/core/offline/offline_queue_manager.dart';

class InMemoryOfflineQueue implements OfflineOperationQueue {
  final List<OfflineOperation> _items = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> enqueue(OfflineOperation operation) async {
    _items.add(operation);
  }

  @override
  Future<void> incrementAttempt(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(attempt: _items[index].attempt + 1);
  }

  @override
  Future<List<OfflineOperation>> listPending({int limit = 100}) async {
    return _items.take(limit).toList();
  }

  @override
  Future<void> markProcessed(String id) async {
    _items.removeWhere((item) => item.id == id);
  }
}

void main() {
  test('OfflineQueueManager replays operations in FIFO order', () async {
    final queue = InMemoryOfflineQueue();
    final manager = OfflineQueueManager(queue);

    await queue.enqueue(
      OfflineOperation(
        id: 'op-1',
        feature: 'tasks',
        action: 'create',
        payload: const {'title': 'first'},
        createdAt: DateTime.utc(2026, 1, 1),
        attempt: 0,
      ),
    );
    await queue.enqueue(
      OfflineOperation(
        id: 'op-2',
        feature: 'tasks',
        action: 'create',
        payload: const {'title': 'second'},
        createdAt: DateTime.utc(2026, 1, 2),
        attempt: 0,
      ),
    );

    final replayed = <String>[];
    await manager.replay((operation) async {
      replayed.add(operation.id);
    });

    expect(replayed, ['op-1', 'op-2']);
    expect(await queue.listPending(), isEmpty);
  });
}
