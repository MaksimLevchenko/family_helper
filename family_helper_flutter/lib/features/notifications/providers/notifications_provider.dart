import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_error_classifier.dart';
import '../../../core/offline/offline_operation.dart';
import '../../../core/offline/offline_queue_manager.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/local_notification_service.dart';
import '../data/notifications_repository.dart';

class NotificationsState {
  const NotificationsState({
    required this.isLoading,
    required this.reminders,
    required this.localNotificationsEnabled,
    this.lastRegisteredPushToken,
    this.error,
  });

  final bool isLoading;
  final List<ReminderDto> reminders;
  final bool localNotificationsEnabled;
  final String? lastRegisteredPushToken;
  final String? error;

  factory NotificationsState.initial() {
    return const NotificationsState(
      isLoading: false,
      reminders: [],
      localNotificationsEnabled: false,
    );
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<ReminderDto>? reminders,
    bool? localNotificationsEnabled,
    String? lastRegisteredPushToken,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      localNotificationsEnabled:
          localNotificationsEnabled ?? this.localNotificationsEnabled,
      lastRegisteredPushToken:
          lastRegisteredPushToken ?? this.lastRegisteredPushToken,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required LocalNotificationService localNotificationService,
    required OfflineQueueManager offlineQueueManager,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _localNotificationService = localNotificationService,
       _offlineQueueManager = offlineQueueManager,
       super(NotificationsState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
  }

  final NotificationsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final LocalNotificationService _localNotificationService;
  final OfflineQueueManager _offlineQueueManager;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  StreamSubscription<int?>? _familySub;
  static const _pushTokenStorageKey = 'notifications_push_token';
  static const _offlineFeature = 'notifications';
  static const _actionRegisterPushToken = 'register_push_token';
  static const _actionSetPreference = 'set_preference';
  static const _actionScheduleReminder = 'schedule_reminder';

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset();
    if (familyId == null) {
      return;
    }
    await _replayQueuedOperations();
    await reloadReminders();
  }

  void reset() {
    emit(
      NotificationsState.initial().copyWith(
        localNotificationsEnabled: state.localNotificationsEnabled,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
      ),
    );
  }

  Future<void> initializeLocalReminders() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _replayQueuedOperations();
      final granted = await _localNotificationService
          .initializeAndRequestPermissions();
      String? token;
      if (granted) {
        token = await _ensureStablePushToken();
        await _registerPushToken(
          token: token,
          platform: _platformName(),
          showLoadingState: false,
        );
      }
      emit(
        state.copyWith(
          isLoading: false,
          localNotificationsEnabled: granted,
          lastRegisteredPushToken: token ?? state.lastRegisteredPushToken,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.initializeLocalReminders',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> reloadReminders({String? status}) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(reminders: const [], clearError: true));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _replayQueuedOperations();
      final reminders = await _repository.listReminders(
        familyId: familyId,
        status: status,
      );
      emit(
        state.copyWith(
          isLoading: false,
          reminders: reminders,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.reloadReminders',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> registerPushToken({
    required String token,
    String? platform,
  }) async {
    await _registerPushToken(
      token: token,
      platform: platform ?? _platformName(),
      showLoadingState: true,
    );
  }

  Future<void> setPreference({
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      await _repository.upsertPreference(
        clientOperationId: clientOperationId,
        notificationType: notificationType,
        enabled: enabled,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
      );
      emit(state.copyWith(isLoading: false, clearError: true));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.setPreference',
        error: error,
        stackTrace: stackTrace,
        context: {'notificationType': notificationType},
      );
      if (isOfflineRecoverableError(error)) {
        await _enqueueOfflineOperation(
          action: _actionSetPreference,
          payload: {
            'clientOperationId': clientOperationId,
            'notificationType': notificationType,
            'enabled': enabled,
            'quietHoursStart': quietHoursStart,
            'quietHoursEnd': quietHoursEnd,
          },
        );
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Network unavailable. Preference change queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> scheduleReminder({
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      final reminder = await _repository.scheduleReminder(
        clientOperationId: clientOperationId,
        familyId: familyId,
        entityType: entityType,
        entityId: entityId,
        remindAt: remindAt,
        payloadJson: payloadJson,
      );

      await _localNotificationService.scheduleReminder(
        id: reminder.id,
        title: 'Reminder',
        body: 'Reminder for ${reminder.entityType}',
        scheduledAt: reminder.remindAt.toLocal(),
      );

      emit(
        state.copyWith(
          isLoading: false,
          reminders: [...state.reminders, reminder],
          clearError: true,
        ),
      );
      await reloadReminders();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.scheduleReminder',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'entityType': entityType,
          'entityId': entityId,
        },
      );
      if (isOfflineRecoverableError(error)) {
        await _enqueueOfflineOperation(
          action: _actionScheduleReminder,
          payload: {
            'clientOperationId': clientOperationId,
            'familyId': familyId,
            'entityType': entityType,
            'entityId': entityId,
            'remindAt': remindAt.toUtc().toIso8601String(),
            'payloadJson': payloadJson,
          },
        );
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Network unavailable. Reminder queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> _registerPushToken({
    required String token,
    required String platform,
    required bool showLoadingState,
  }) async {
    if (showLoadingState) {
      emit(state.copyWith(isLoading: true, clearError: true));
    }
    final clientOperationId = OperationId.next();
    try {
      await _repository.registerPushToken(
        clientOperationId: clientOperationId,
        token: token,
        platform: platform,
      );
      await _storage.write(key: _pushTokenStorageKey, value: token);
      emit(
        state.copyWith(
          isLoading: false,
          lastRegisteredPushToken: token,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.registerPushToken',
        error: error,
        stackTrace: stackTrace,
        context: {'platform': platform},
      );
      if (isOfflineRecoverableError(error)) {
        await _storage.write(key: _pushTokenStorageKey, value: token);
        await _enqueueOfflineOperation(
          action: _actionRegisterPushToken,
          payload: {
            'clientOperationId': clientOperationId,
            'token': token,
            'platform': platform,
          },
        );
        emit(
          state.copyWith(
            isLoading: false,
            lastRegisteredPushToken: token,
            error: 'Network unavailable. Push token registration queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<String> _ensureStablePushToken() async {
    final existing = await _storage.read(key: _pushTokenStorageKey);
    if (existing != null && existing.trim().isNotEmpty) {
      return existing;
    }
    final token = 'app-${_platformName()}-${const Uuid().v4()}';
    await _storage.write(key: _pushTokenStorageKey, value: token);
    return token;
  }

  Future<void> _enqueueOfflineOperation({
    required String action,
    required Map<String, dynamic> payload,
  }) {
    return _offlineQueueManager.enqueue(
      OfflineOperation(
        id: OperationId.next(),
        feature: _offlineFeature,
        action: action,
        payload: payload,
        createdAt: DateTime.now().toUtc(),
        attempt: 0,
      ),
    );
  }

  Future<void> _replayQueuedOperations() {
    return _offlineQueueManager.replayWhere(
      (operation) async {
        switch (operation.action) {
          case _actionRegisterPushToken:
            await _repository.registerPushToken(
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
              token: operation.payload['token'] as String,
              platform: operation.payload['platform'] as String,
            );
            return;
          case _actionSetPreference:
            await _repository.upsertPreference(
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
              notificationType: operation.payload['notificationType'] as String,
              enabled: operation.payload['enabled'] as bool,
              quietHoursStart: operation.payload['quietHoursStart'] as String?,
              quietHoursEnd: operation.payload['quietHoursEnd'] as String?,
            );
            return;
          case _actionScheduleReminder:
            await _repository.scheduleReminder(
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
              familyId: operation.payload['familyId'] as int,
              entityType: operation.payload['entityType'] as String,
              entityId: operation.payload['entityId'] as int,
              remindAt: DateTime.parse(
                operation.payload['remindAt'] as String,
              ).toUtc(),
              payloadJson: operation.payload['payloadJson'] as String,
            );
            return;
        }
      },
      canProcess: (operation) => operation.feature == _offlineFeature,
    );
  }

  String _platformName() {
    if (kIsWeb) {
      return 'web';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
