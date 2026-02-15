import 'dart:io';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/local_notification_service.dart';
import '../data/notifications_repository.dart';

class NotificationsState {
  const NotificationsState({
    required this.isLoading,
    required this.reminders,
    this.error,
  });

  final bool isLoading;
  final List<ReminderDto> reminders;
  final String? error;

  factory NotificationsState.initial() {
    return const NotificationsState(isLoading: false, reminders: []);
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<ReminderDto>? reminders,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required LocalNotificationService localNotificationService,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _localNotificationService = localNotificationService,
       super(NotificationsState.initial());

  final NotificationsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final LocalNotificationService _localNotificationService;

  Future<void> initPush() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      try {
        await Firebase.initializeApp();
      } catch (_) {}

      final messaging = FirebaseMessaging.instance;
      final permission = await messaging.requestPermission();
      if (permission.authorizationStatus == AuthorizationStatus.denied) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final token = await messaging.getToken();
      if (token == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      await _repository.registerPushToken(
        clientOperationId: OperationId.next(),
        token: token,
        platform: Platform.isAndroid ? 'android' : 'unknown',
      );

      await _localNotificationService.initialize();
      emit(state.copyWith(isLoading: false, clearError: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> setPreference({
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.upsertPreference(
        clientOperationId: OperationId.next(),
        notificationType: notificationType,
        enabled: enabled,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
      );
      emit(state.copyWith(isLoading: false, clearError: true));
    } catch (error) {
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
    try {
      final reminder = await _repository.scheduleReminder(
        clientOperationId: OperationId.next(),
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
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<int?> processDueReminders() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final processed = await _repository.processDueReminders();
      emit(state.copyWith(isLoading: false, clearError: true));
      return processed;
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: '$error'));
      return null;
    }
  }
}
