import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../logging/app_error_logger.dart';
import 'app_api_client.dart';

enum ServerAvailabilityStatus {
  checking,
  available,
  unavailable,
}

class ServerAvailabilityState {
  const ServerAvailabilityState({
    this.status = ServerAvailabilityStatus.checking,
    this.lastCheckedAt,
  });

  final ServerAvailabilityStatus status;
  final DateTime? lastCheckedAt;

  bool get isUnavailable => status == ServerAvailabilityStatus.unavailable;

  ServerAvailabilityState copyWith({
    ServerAvailabilityStatus? status,
    DateTime? lastCheckedAt,
    bool clearLastCheckedAt = false,
  }) {
    return ServerAvailabilityState(
      status: status ?? this.status,
      lastCheckedAt: clearLastCheckedAt
          ? null
          : (lastCheckedAt ?? this.lastCheckedAt),
    );
  }
}

class ServerAvailabilityCubit extends Cubit<ServerAvailabilityState> {
  ServerAvailabilityCubit(
    AppApiClient? apiClient, {
    Future<bool> Function()? pingServer,
    Duration pollInterval = const Duration(seconds: 15),
    DateTime Function()? now,
  }) : _pingServer = pingServer ?? (() => apiClient!.client.health.ping()),
       _pollInterval = pollInterval,
       _now = now ?? DateTime.now,
       super(const ServerAvailabilityState());

  final Future<bool> Function() _pingServer;
  final Duration _pollInterval;
  final DateTime Function() _now;

  Timer? _pollingTimer;
  Future<void>? _inFlight;
  bool _started = false;

  void start() {
    if (_started) {
      return;
    }
    _started = true;
    unawaited(refresh());
    _pollingTimer = Timer.periodic(_pollInterval, (_) {
      unawaited(refresh());
    });
  }

  Future<void> refresh() async {
    final existing = _inFlight;
    if (existing != null) {
      return existing;
    }

    final future = _performRefresh();
    _inFlight = future;
    try {
      await future;
    } finally {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    }
  }

  Future<void> _performRefresh() async {
    try {
      await _pingServer();
      if (isClosed) {
        return;
      }
      emit(
        state.copyWith(
          status: ServerAvailabilityStatus.available,
          lastCheckedAt: _now(),
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'network.serverAvailabilityPing',
        error: error,
        stackTrace: stackTrace,
      );
      if (isClosed) {
        return;
      }
      emit(
        state.copyWith(
          status: ServerAvailabilityStatus.unavailable,
          lastCheckedAt: _now(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    return super.close();
  }
}
