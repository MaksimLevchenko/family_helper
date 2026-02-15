import 'offline_operation.dart';
import 'offline_operation_queue.dart';

class OfflineQueueManager {
  const OfflineQueueManager(this._queue);

  final OfflineOperationQueue _queue;

  Future<void> enqueue(OfflineOperation operation) {
    return _queue.enqueue(operation);
  }

  Future<void> replay(
    Future<void> Function(OfflineOperation operation) processor,
  ) async {
    final pending = await _queue.listPending();
    for (final operation in pending) {
      try {
        await processor(operation);
        await _queue.markProcessed(operation.id);
      } catch (_) {
        await _queue.incrementAttempt(operation.id);
      }
    }
  }
}
