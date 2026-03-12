import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/config/app_defaults.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/notifications/presentation/notifications_screen.dart';
import 'package:family_helper_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestNotificationsCubit extends Cubit<NotificationsState>
    implements NotificationsCubit {
  _TestNotificationsCubit(super.initialState);

  bool didLoadPreferences = false;
  bool didRefreshPermissionStatus = false;

  @override
  bool isPreferenceEnabled(String notificationType) {
    return state.preferences.any(
      (preference) =>
          preference.notificationType == notificationType && preference.enabled,
    );
  }

  @override
  Future<void> loadPreferences() async {
    didLoadPreferences = true;
  }

  @override
  Future<void> refreshPermissionStatus() async {
    didRefreshPermissionStatus = true;
  }

  @override
  Future<NotificationPermissionStatus> requestSystemPermission() async {
    emit(
      state.copyWith(permissionStatus: NotificationPermissionStatus.granted),
    );
    return state.permissionStatus;
  }

  @override
  Future<bool> openSystemNotificationSettings() async => true;

  @override
  Future<void> reloadReminders({String? status}) async {}

  @override
  Future<void> registerPushToken({
    required String token,
    String? platform,
  }) async {}

  @override
  void reset({bool preserveAccountSettings = false}) {
    emit(NotificationsState.initial());
  }

  @override
  Future<ReminderActionResult> scheduleReminder({
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async {
    return ReminderActionResult.successResult;
  }

  @override
  Future<ReminderActionResult> ensureReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async {
    return ReminderActionResult.successResult;
  }

  @override
  Future<bool> setPreference({
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async {
    final existingIndex = state.preferences.indexWhere(
      (preference) => preference.notificationType == notificationType,
    );
    final updated = NotificationPreferenceDto(
      id: existingIndex == -1
          ? state.preferences.length + 1
          : state.preferences[existingIndex].id,
      profileId: 1,
      notificationType: notificationType,
      enabled: enabled,
      updatedAt: DateTime.utc(2026, 3, 12),
    );
    final preferences = [...state.preferences];
    if (existingIndex == -1) {
      preferences.add(updated);
    } else {
      preferences[existingIndex] = updated;
    }
    emit(state.copyWith(preferences: preferences));
    return true;
  }

  @override
  Future<NotificationPermissionStatus> requestSystemPermissionIfNeeded() async {
    return state.permissionStatus;
  }
}

void main() {
  Widget buildSubject(_TestNotificationsCubit cubit) {
    return BlocProvider<NotificationsCubit>.value(
      value: cubit,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const NotificationsScreen(),
      ),
    );
  }

  testWidgets(
    'NotificationsScreen shows CTA and separate task/calendar toggles',
    (
      tester,
    ) async {
      final cubit = _TestNotificationsCubit(
        NotificationsState.initial().copyWith(
          permissionStatus: NotificationPermissionStatus.notDetermined,
          preferences: [
            NotificationPreferenceDto(
              id: 1,
              profileId: 1,
              notificationType: AppDefaults.taskNotificationType,
              enabled: false,
              updatedAt: DateTime.utc(2026, 3, 12),
            ),
            NotificationPreferenceDto(
              id: 2,
              profileId: 1,
              notificationType: AppDefaults.calendarNotificationType,
              enabled: true,
              updatedAt: DateTime.utc(2026, 3, 12),
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.text('Allow notifications'), findsOneWidget);
      expect(find.text('Task reminders'), findsOneWidget);
      expect(find.text('Calendar reminders'), findsOneWidget);
      expect(find.textContaining('push token'), findsNothing);
      expect(find.textContaining('entity id'), findsNothing);
      expect(cubit.didLoadPreferences, isTrue);
      expect(cubit.didRefreshPermissionStatus, isTrue);

      await tester.tap(find.text('Task reminders'));
      await tester.pump();

      expect(
        cubit.isPreferenceEnabled(AppDefaults.taskNotificationType),
        isTrue,
      );

      await cubit.close();
    },
  );

  testWidgets(
    'NotificationsScreen hides action button when permission is granted',
    (
      tester,
    ) async {
      final cubit = _TestNotificationsCubit(
        NotificationsState.initial().copyWith(
          permissionStatus: NotificationPermissionStatus.granted,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.text('Notifications enabled'), findsOneWidget);
      expect(find.text('Allow notifications'), findsNothing);
      expect(find.text('Open system settings'), findsNothing);

      await cubit.close();
    },
  );
}
