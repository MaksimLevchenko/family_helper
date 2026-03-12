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
import '../domain/notification_models.dart';

class NotificationsState {
  const NotificationsState({
    required this.isLoading,
    required this.reminders,
    required this.preferences,
    required this.permissionStatus,
    this.lastRegisteredPushToken,
    this.error,
  });

  final bool isLoading;
  final List<ReminderDto> reminders;
  final List<NotificationPreferenceDto> preferences;
  final NotificationPermissionStatus permissionStatus;
  final String? lastRegisteredPushToken;
  final String? error;

  factory NotificationsState.initial() {
    return const NotificationsState(
      isLoading: false,
      reminders: [],
      preferences: [],
      permissionStatus: NotificationPermissionStatus.notDetermined,
    );
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<ReminderDto>? reminders,
    List<NotificationPreferenceDto>? preferences,
    NotificationPermissionStatus? permissionStatus,
    String? lastRegisteredPushToken,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      preferences: preferences ?? this.preferences,
      permissionStatus: permissionStatus ?? this.permissionStatus,
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
    reset(preserveAccountSettings: true);
    if (familyId == null) {
      return;
    }
    await _replayQueuedOperations();
    await reloadReminders();
  }

  void reset({bool preserveAccountSettings = false}) {
    emit(
      NotificationsState.initial().copyWith(
        preferences: preserveAccountSettings ? state.preferences : const [],
        permissionStatus: preserveAccountSettings
            ? state.permissionStatus
            : NotificationPermissionStatus.notDetermined,
        lastRegisteredPushToken: preserveAccountSettings
            ? state.lastRegisteredPushToken
            : null,
      ),
    );
  }

  bool isPreferenceEnabled(String notificationType) {
    return state.preferences.any(
      (preference) =>
          preference.notificationType == notificationType && preference.enabled,
    );
  }

  Future<void> loadPreferences() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final preferences = await _repository.listPreferences();
      emit(
        state.copyWith(
          isLoading: false,
          preferences: preferences,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.loadPreferences',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> refreshPermissionStatus() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final permissionStatus = await _localNotificationService
          .getPermissionStatus();
      final token = await _registerPushTokenIfNeeded(
        permissionStatus: permissionStatus,
      );
      emit(
        state.copyWith(
          isLoading: false,
          permissionStatus: permissionStatus,
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

  Future<NotificationPermissionStatus> requestSystemPermission() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final permissionStatus = await _localNotificationService
          .requestPermissions();
      final token = await _registerPushTokenIfNeeded(
        permissionStatus: permissionStatus,
      );
      emit(
        state.copyWith(
          isLoading: false,
          permissionStatus: permissionStatus,
          lastRegisteredPushToken: token ?? state.lastRegisteredPushToken,
          clearError: true,
        ),
      );
      return permissionStatus;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.requestSystemPermission',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return state.permissionStatus;
    }
  }

  Future<bool> openSystemNotificationSettings() {
    return _localNotificationService.openNotificationSettings();
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

  Future<bool> setPreference({
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      final preference = await _repository.upsertPreference(
        clientOperationId: clientOperationId,
        notificationType: notificationType,
        enabled: enabled,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
      );
      emit(
        state.copyWith(
          isLoading: false,
          preferences: _mergePreference(state.preferences, preference),
          clearError: true,
        ),
      );
      return true;
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
        return true;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
      return false;
    }
  }

  Future<ReminderActionResult> scheduleReminder({
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return ReminderActionResult.failure('Family is not selected.');
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
        title: title,
        body: body,
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
      return ReminderActionResult.successResult;
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
        return const ReminderActionResult(
          success: true,
          message: 'Reminder will sync when your connection returns.',
        );
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
      return ReminderActionResult.failure('Unable to save the reminder.');
    }
  }

  Future<ReminderActionResult> ensureReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async {
    final permissionStatus = await requestSystemPermissionIfNeeded();
    if (!permissionStatus.isGranted) {
      final message = switch (permissionStatus) {
        NotificationPermissionStatus.notDetermined =>
          'Allow notifications to receive reminders on this device.',
        NotificationPermissionStatus.denied =>
          'Notifications are blocked. Open system settings to enable reminders.',
        NotificationPermissionStatus.permanentlyDenied =>
          'Notifications are disabled in system settings. Re-enable them there to get reminders.',
        NotificationPermissionStatus.granted => null,
      };
      return ReminderActionResult.failure(message!);
    }

    if (!isPreferenceEnabled(notificationType)) {
      final enabled = await setPreference(
        notificationType: notificationType,
        enabled: true,
      );
      if (!enabled) {
        return ReminderActionResult.failure(
          'Unable to enable reminders right now. Please try again.',
        );
      }
    }

    return scheduleReminder(
      entityType: entityType,
      entityId: entityId,
      remindAt: remindAt,
      payloadJson: payloadJson,
      title: title,
      body: body,
    );
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

  Future<String?> _registerPushTokenIfNeeded({
    required NotificationPermissionStatus permissionStatus,
  }) async {
    if (!permissionStatus.isGranted) {
      return null;
    }

    await _replayQueuedOperations();
    final token = await _ensureStablePushToken();
    if (token == state.lastRegisteredPushToken) {
      return token;
    }

    await _registerPushToken(
      token: token,
      platform: _platformName(),
      showLoadingState: false,
    );
    return token;
  }

  Future<NotificationPermissionStatus> requestSystemPermissionIfNeeded() async {
    final permissionStatus = await _localNotificationService
        .getPermissionStatus();
    emit(state.copyWith(permissionStatus: permissionStatus));
    if (permissionStatus == NotificationPermissionStatus.notDetermined) {
      return requestSystemPermission();
    }
    return permissionStatus;
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

  List<NotificationPreferenceDto> _mergePreference(
    List<NotificationPreferenceDto> current,
    NotificationPreferenceDto updated,
  ) {
    final next = [...current];
    final index = next.indexWhere(
      (preference) => preference.notificationType == updated.notificationType,
    );
    if (index == -1) {
      next.add(updated);
    } else {
      next[index] = updated;
    }
    next.sort((left, right) {
      return left.notificationType.compareTo(right.notificationType);
    });
    return next;
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
