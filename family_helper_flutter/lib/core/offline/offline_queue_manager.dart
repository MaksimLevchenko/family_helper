import 'offline_operation.dart';
import 'offline_operation_queue.dart';

class OfflineQueueManager {
  const OfflineQueueManager(
    this._queue, {
    this.maxAttempts = 5,
    this.initialBackoff = const Duration(milliseconds: 500),
    this.maxBackoff = const Duration(seconds: 30),
  });

  final OfflineOperationQueue _queue;
  final int maxAttempts;
  final Duration initialBackoff;
  final Duration maxBackoff;

  Future<void> enqueue(OfflineOperation operation) {
    return _queue.enqueue(operation);
  }

  Future<void> replay(
    Future<void> Function(OfflineOperation operation) processor,
  ) async {
    return replayWhere(processor);
  }

  Future<void> replayWhere(
    Future<void> Function(OfflineOperation operation) processor, {
    bool Function(OfflineOperation operation)? canProcess,
  }) async {
    final pending = await _queue.listPending();
    for (final operation in pending) {
      if (canProcess != null && !canProcess(operation)) {
        continue;
      }
      if (operation.attempt >= maxAttempts) {
        await _queue.markProcessed(operation.id);
        continue;
      }

      try {
        await processor(operation);
        await _queue.markProcessed(operation.id);
      } catch (_) {
        final nextAttempt = operation.attempt + 1;
        await _queue.incrementAttempt(operation.id);
        await Future<void>.delayed(_backoffFor(nextAttempt));
      }
    }
  }

  Duration _backoffFor(int attempt) {
    final exponent = (attempt - 1).clamp(0, 20);
    final multiplier = 1 << exponent;
    final backoffMs = initialBackoff.inMilliseconds * multiplier;
    final clampedMs = backoffMs > maxBackoff.inMilliseconds
        ? maxBackoff.inMilliseconds
        : backoffMs;
    return Duration(milliseconds: clampedMs);
  }
}
