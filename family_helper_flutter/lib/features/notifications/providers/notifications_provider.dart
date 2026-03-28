import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_error_classifier.dart';
import '../../../core/offline/offline_operation.dart';
import '../../../core/offline/offline_queue_manager.dart';
import '../../../core/offline/offline_snapshot_store.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/local_notification_service.dart';
import '../data/notifications_repository.dart';
import '../data/push_notification_service.dart';
import '../domain/notification_models.dart';

class NotificationsState {
  const NotificationsState({
    required this.isLoading,
    required this.reminders,
    required this.preferences,
    this.inbox = const [],
    this.inboxHasMore = false,
    this.unreadCount = 0,
    required this.permissionStatus,
    this.lastRegisteredPushToken,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final bool isLoading;
  final List<ReminderDto> reminders;
  final List<NotificationPreferenceDto> preferences;
  final List<AppNotificationDto> inbox;
  final bool inboxHasMore;
  final int unreadCount;
  final NotificationPermissionStatus permissionStatus;
  final String? lastRegisteredPushToken;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final String? error;

  factory NotificationsState.initial() {
    return const NotificationsState(
      isLoading: false,
      reminders: [],
      preferences: [],
      inbox: [],
      inboxHasMore: false,
      unreadCount: 0,
      permissionStatus: NotificationPermissionStatus.notDetermined,
    );
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<ReminderDto>? reminders,
    List<NotificationPreferenceDto>? preferences,
    List<AppNotificationDto>? inbox,
    bool? inboxHasMore,
    int? unreadCount,
    NotificationPermissionStatus? permissionStatus,
    String? lastRegisteredPushToken,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    String? error,
    bool clearError = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      preferences: preferences ?? this.preferences,
      inbox: inbox ?? this.inbox,
      inboxHasMore: inboxHasMore ?? this.inboxHasMore,
      unreadCount: unreadCount ?? this.unreadCount,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      lastRegisteredPushToken:
          lastRegisteredPushToken ?? this.lastRegisteredPushToken,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required LocalNotificationService localNotificationService,
    required PushNotificationService pushNotificationService,
    required OfflineQueueManager offlineQueueManager,
    OfflineSnapshotStore? snapshotStore,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _localNotificationService = localNotificationService,
       _pushNotificationService = pushNotificationService,
       _offlineQueueManager = offlineQueueManager,
       _snapshotStore = snapshotStore,
       super(NotificationsState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
    _pushTokenSub = _pushNotificationService.tokenRefreshes.listen((token) {
      unawaited(
        _registerPushToken(
          token: token,
          platform: _platformName(),
          provider: 'fcm',
          showLoadingState: false,
        ),
      );
    });
    unawaited(_restoreSnapshot(_familySelectionCubit.state));
  }

  final NotificationsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final LocalNotificationService _localNotificationService;
  final PushNotificationService _pushNotificationService;
  final OfflineQueueManager _offlineQueueManager;
  final OfflineSnapshotStore? _snapshotStore;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  StreamSubscription<int?>? _familySub;
  StreamSubscription<String>? _pushTokenSub;
  static const _pushTokenStorageKey = 'notifications_push_token';
  static const _offlineFeature = 'notifications';
  static const _actionRegisterPushToken = 'register_push_token';
  static const _actionSetPreference = 'set_preference';
  static const _actionScheduleReminder = 'schedule_reminder';

  bool get _hasLocalState {
    return state.preferences.isNotEmpty ||
        state.reminders.isNotEmpty ||
        state.inbox.isNotEmpty ||
        state.unreadCount > 0;
  }

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset(preserveAccountSettings: true);
    if (familyId == null) {
      await refreshUnreadCount();
      return;
    }
    await _restoreSnapshot(familyId);
    await refreshUnreadCount();
    await _replayQueuedOperations();
    await Future.wait([
      loadPreferences(),
      reloadReminders(),
      reloadInbox(),
    ]);
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
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: _familySelectionCubit.state,
        reminders: state.reminders,
        preferences: preferences,
        inbox: state.inbox,
        unreadCount: state.unreadCount,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          preferences: preferences,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.loadPreferences',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData: _hasLocalState,
          error: '$error',
        ),
      );
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
        scope: 'notifications.refreshPermissionStatus',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<NotificationPermissionStatus> requestSystemPermission() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _pushNotificationService.requestPermissions();
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

  Future<bool> openSystemNotificationSettings() async {
    final opened = await _localNotificationService.openNotificationSettings();
    if (opened) {
      unawaited(refreshPermissionStatus());
    }
    return opened;
  }

  Future<void> reloadReminders({String? status}) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(
        state.copyWith(
          reminders: const [],
          clearError: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _replayQueuedOperations();
      final reminders = await _repository.listReminders(
        familyId: familyId,
        status: status,
      );
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: familyId,
        reminders: reminders,
        preferences: state.preferences,
        inbox: state.inbox,
        unreadCount: state.unreadCount,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          reminders: reminders,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
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
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData: _hasLocalState,
          error: '$error',
        ),
      );
    }
  }

  Future<void> reloadInbox({
    bool unreadOnly = false,
    DateTime? before,
    bool append = false,
    int limit = 50,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(
        state.copyWith(
          inbox: const [],
          inboxHasMore: false,
          unreadCount: 0,
          clearError: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final cursor =
          before ??
          (append && state.inbox.isNotEmpty
              ? state.inbox.last.createdAt
              : null);
      final results = await Future.wait<dynamic>([
        _repository.listInbox(
          familyId: familyId,
          unreadOnly: unreadOnly,
          limit: limit,
          before: cursor,
        ),
        _repository.unreadCount(familyId: familyId),
      ]);
      final response = results[0] as AppNotificationListResponse;
      final unreadCount = results[1] as int;
      final nextInbox = append
          ? _mergeInbox(state.inbox, response.items)
          : response.items;
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: familyId,
        reminders: state.reminders,
        preferences: state.preferences,
        inbox: nextInbox,
        unreadCount: unreadCount,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          inbox: nextInbox,
          inboxHasMore: response.hasMore,
          unreadCount: unreadCount,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.reloadInbox',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'unreadOnly': unreadOnly,
          'append': append,
        },
      );
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData: _hasLocalState,
          error: '$error',
        ),
      );
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
    final existingPreference = _findPreference(notificationType);
    final nextPreferences = _mergePreference(
      state.preferences,
      NotificationPreferenceDto(
        id: existingPreference?.id ?? 0,
        profileId: existingPreference?.profileId ?? 0,
        notificationType: notificationType,
        enabled: enabled,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    try {
      final preference = await _repository.upsertPreference(
        clientOperationId: clientOperationId,
        notificationType: notificationType,
        enabled: enabled,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
      );
      final mergedPreferences = _mergePreference(state.preferences, preference);
      emit(
        state.copyWith(
          isLoading: false,
          preferences: mergedPreferences,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
      await _writeSnapshot(
        familyId: _familySelectionCubit.state,
        reminders: state.reminders,
        preferences: mergedPreferences,
        inbox: state.inbox,
        unreadCount: state.unreadCount,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
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
            preferences: nextPreferences,
            isUsingCachedData: true,
            error: 'Network unavailable. Preference change queued.',
          ),
        );
        await _writeSnapshot(
          familyId: _familySelectionCubit.state,
          reminders: state.reminders,
          preferences: nextPreferences,
          inbox: state.inbox,
          unreadCount: state.unreadCount,
          lastRegisteredPushToken: state.lastRegisteredPushToken,
          syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
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
        payload: payloadJson,
      );

      emit(
        state.copyWith(
          isLoading: false,
          reminders: [...state.reminders, reminder],
          isUsingCachedData: false,
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
            isUsingCachedData: _hasLocalState,
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

  Future<ReminderActionResult> replaceEntityReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    DateTime? remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return ReminderActionResult.failure('Family is not selected.');
    }

    if (remindAt != null) {
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
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    final activeReminderIds = _activeReminderIdsForEntity(
      entityType: entityType,
      entityId: entityId,
    );
    try {
      final reminder = await _repository.replaceReminder(
        clientOperationId: clientOperationId,
        familyId: familyId,
        entityType: entityType,
        entityId: entityId,
        remindAt: remindAt,
        payloadJson: payloadJson,
      );

      for (final reminderId in activeReminderIds) {
        await _localNotificationService.cancelReminder(reminderId);
      }
      if (reminder != null) {
        await _localNotificationService.scheduleReminder(
          id: reminder.id,
          title: title,
          body: body,
          scheduledAt: reminder.remindAt.toLocal(),
          payload: payloadJson,
        );
      }

      await reloadReminders();
      return ReminderActionResult(
        success: true,
        message: reminder == null ? 'Reminder removed.' : null,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.replaceReminder',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'entityType': entityType,
          'entityId': entityId,
          'hasRemindAt': remindAt != null,
        },
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return ReminderActionResult.failure('Unable to update the reminder.');
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

  Future<ReminderActionResult> scheduleDebugNotification() async {
    if (!kDebugMode) {
      return ReminderActionResult.failure(
        'Test pushes are only available in debug builds.',
      );
    }

    final permissionStatus = await requestSystemPermissionIfNeeded();
    if (!permissionStatus.isGranted) {
      final message = switch (permissionStatus) {
        NotificationPermissionStatus.notDetermined =>
          'Allow notifications to receive the test push.',
        NotificationPermissionStatus.denied =>
          'Notifications are blocked. Open system settings to run the push test.',
        NotificationPermissionStatus.permanentlyDenied =>
          'Notifications are disabled in system settings. Re-enable them there to run the push test.',
        NotificationPermissionStatus.granted => null,
      };
      return ReminderActionResult.failure(message!);
    }

    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      return ReminderActionResult.failure(
        'Select a family before sending a test push.',
      );
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();

    try {
      final notification = await _repository.sendTestPush(
        clientOperationId: clientOperationId,
        familyId: familyId,
      );
      await reloadInbox();
      emit(state.copyWith(isLoading: false, clearError: true));
      return ReminderActionResult(
        success: true,
        message: switch (notification.pushStatus) {
          'sent' => 'Test push sent. It should arrive shortly.',
          'skipped' =>
            'Test push was created, but nothing was sent. Check token registration and Firebase server config.',
          'failed' =>
            'Test push dispatch failed. Check server logs and Firebase configuration.',
          _ => 'Test push requested.',
        },
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.scheduleDebugNotification',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return ReminderActionResult.failure(
        'Unable to send the test push.',
      );
    }
  }

  Future<void> markNotificationRead(int notificationId) async {
    final existing = state.inbox.where((item) => item.id == notificationId);
    if (existing.isEmpty) {
      return;
    }

    final updatedInbox = state.inbox.map((item) {
      if (item.id != notificationId || item.isRead) {
        return item;
      }
      return item.copyWith(
        isRead: true,
        readAt: DateTime.now().toUtc(),
      );
    }).toList();
    final nextUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
    emit(
      state.copyWith(
        inbox: updatedInbox,
        unreadCount: nextUnreadCount,
      ),
    );

    try {
      await _repository.markRead(notificationId: notificationId);
      unawaited(refreshUnreadCount());
      await _writeSnapshot(
        familyId: _familySelectionCubit.state,
        reminders: state.reminders,
        preferences: state.preferences,
        inbox: updatedInbox,
        unreadCount: nextUnreadCount,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.markRead',
        error: error,
        stackTrace: stackTrace,
        context: {'notificationId': notificationId},
      );
      emit(state.copyWith(error: '$error'));
      await reloadInbox();
    }
  }

  Future<void> markAllNotificationsRead() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      return;
    }

    final readAt = DateTime.now().toUtc();
    final updatedInbox = state.inbox
        .map(
          (item) =>
              item.isRead ? item : item.copyWith(isRead: true, readAt: readAt),
        )
        .toList();
    emit(
      state.copyWith(
        inbox: updatedInbox,
        unreadCount: 0,
      ),
    );

    try {
      await _repository.markAllRead(familyId: familyId);
      unawaited(refreshUnreadCount());
      await _writeSnapshot(
        familyId: familyId,
        reminders: state.reminders,
        preferences: state.preferences,
        inbox: updatedInbox,
        unreadCount: 0,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.markAllRead',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(error: '$error'));
      await reloadInbox();
    }
  }

  Future<void> refreshUnreadCount() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      if (state.unreadCount != 0) {
        emit(state.copyWith(unreadCount: 0));
      }
      return;
    }

    try {
      final unreadCount = await _repository.unreadCount(familyId: familyId);
      if (isClosed || unreadCount == state.unreadCount) {
        return;
      }

      emit(state.copyWith(unreadCount: unreadCount));
      await _writeSnapshot(
        familyId: familyId,
        reminders: state.reminders,
        preferences: state.preferences,
        inbox: state.inbox,
        unreadCount: unreadCount,
        lastRegisteredPushToken: state.lastRegisteredPushToken,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.refreshUnreadCount',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
    }
  }

  Future<void> _registerPushToken({
    required String token,
    required String platform,
    String? provider,
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
        provider: provider,
      );
      await _storage.write(key: _pushTokenStorageKey, value: token);
      emit(
        state.copyWith(
          isLoading: false,
          lastRegisteredPushToken: token,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
      await _writeSnapshot(
        familyId: _familySelectionCubit.state,
        reminders: state.reminders,
        preferences: state.preferences,
        inbox: state.inbox,
        unreadCount: state.unreadCount,
        lastRegisteredPushToken: token,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.registerPushToken',
        error: error,
        stackTrace: stackTrace,
        context: {
          'platform': platform,
          'provider': provider,
        },
      );
      if (isOfflineRecoverableError(error)) {
        await _storage.write(key: _pushTokenStorageKey, value: token);
        await _enqueueOfflineOperation(
          action: _actionRegisterPushToken,
          payload: {
            'clientOperationId': clientOperationId,
            'token': token,
            'platform': platform,
            'provider': provider,
          },
        );
        emit(
          state.copyWith(
            isLoading: false,
            lastRegisteredPushToken: token,
            isUsingCachedData: _hasLocalState,
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
    final token = await _pushNotificationService.getToken();
    if (token == null || token.trim().isEmpty) {
      return null;
    }
    if (token == state.lastRegisteredPushToken) {
      return token;
    }

    await _registerPushToken(
      token: token,
      platform: _platformName(),
      provider: _pushNotificationService.isConfigured ? 'fcm' : null,
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
    if (permissionStatus.isGranted) {
      unawaited(
        _registerPushTokenIfNeeded(permissionStatus: permissionStatus),
      );
    }
    return permissionStatus;
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

  List<int> _activeReminderIdsForEntity({
    required String entityType,
    required int entityId,
  }) {
    return state.reminders
        .where(
          (reminder) =>
              reminder.entityType == entityType &&
              reminder.entityId == entityId &&
              reminder.status == 'scheduled',
        )
        .map((reminder) => reminder.id)
        .toList();
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
              provider: operation.payload['provider'] as String?,
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

  NotificationPreferenceDto? _findPreference(String notificationType) {
    for (final preference in state.preferences) {
      if (preference.notificationType == notificationType) {
        return preference;
      }
    }
    return null;
  }

  List<AppNotificationDto> _mergeInbox(
    List<AppNotificationDto> current,
    List<AppNotificationDto> incoming,
  ) {
    final byId = <int, AppNotificationDto>{
      for (final item in current) item.id: item,
    };
    for (final item in incoming) {
      byId[item.id] = item;
    }
    final merged = byId.values.toList();
    merged.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return merged;
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    await _pushTokenSub?.cancel();
    return super.close();
  }

  Future<void> _restoreSnapshot(int? familyId) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey(familyId));
      if (snapshot == null || isClosed) {
        return;
      }

      final reminders =
          (snapshot.payload['reminders'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(ReminderDto.fromJson)
              .toList();
      final preferences =
          (snapshot.payload['preferences'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(NotificationPreferenceDto.fromJson)
              .toList();
      final inbox =
          (snapshot.payload['inbox'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(AppNotificationDto.fromJson)
              .toList()
            ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
      emit(
        state.copyWith(
          isLoading: false,
          reminders: reminders,
          preferences: preferences,
          inbox: inbox,
          inboxHasMore: false,
          unreadCount: snapshot.payload['unreadCount'] as int? ?? 0,
          lastRegisteredPushToken:
              snapshot.payload['lastRegisteredPushToken'] as String?,
          isUsingCachedData: true,
          lastSuccessfulSyncAt: snapshot.updatedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.restoreSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
    }
  }

  Future<void> _writeSnapshot({
    required int? familyId,
    required List<ReminderDto> reminders,
    required List<NotificationPreferenceDto> preferences,
    required List<AppNotificationDto> inbox,
    required int unreadCount,
    required String? lastRegisteredPushToken,
    required DateTime syncedAt,
  }) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey(familyId), {
        'reminders': reminders.map((reminder) => reminder.toJson()).toList(),
        'preferences': preferences
            .map((preference) => preference.toJson())
            .toList(),
        'inbox': inbox.map((notification) => notification.toJson()).toList(),
        'unreadCount': unreadCount,
        'lastRegisteredPushToken': lastRegisteredPushToken,
      }, updatedAt: syncedAt);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'notifications.writeSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'remindersCount': reminders.length,
          'preferencesCount': preferences.length,
          'inboxCount': inbox.length,
          'unreadCount': unreadCount,
        },
      );
    }
  }

  String _cacheKey(int? familyId) => familyId == null
      ? 'notifications/account'
      : 'notifications/family/$familyId';
}
