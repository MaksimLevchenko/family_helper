import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
import '../../../ui_kit/ui_kit.dart';
import '../domain/notification_models.dart';
import '../providers/notifications_provider.dart';

part 'notification_settings_screen_parts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<NotificationsCubit>();
      cubit.refreshPermissionStatus();
      cubit.loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: serverStatusAppBar(
        context,
        title: Text(context.l10n.notificationsSettingsTitle),
        showNotificationAction: false,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final taskRemindersEnabled = _preferenceEnabled(
            state.preferences,
            AppDefaults.taskNotificationType,
          );
          final calendarRemindersEnabled = _preferenceEnabled(
            state.preferences,
            AppDefaults.calendarNotificationType,
          );

          final reminderCards = <Widget>[
            _PreferenceCard(
              value: taskRemindersEnabled,
              onChanged: (value) async {
                await context.read<NotificationsCubit>().setPreference(
                  notificationType: AppDefaults.taskNotificationType,
                  enabled: value,
                );
              },
              title: context.l10n.notificationsTaskReminders,
              subtitle: state.permissionStatus.isGranted
                  ? (taskRemindersEnabled
                        ? context.l10n.notificationsTaskRemindersOn
                        : context.l10n.notificationsTaskRemindersOff)
                  : context.l10n.notificationsTaskRemindersNeedsPermission,
            ),
            const SizedBox(height: 12),
            _PreferenceCard(
              value: calendarRemindersEnabled,
              onChanged: (value) async {
                await context.read<NotificationsCubit>().setPreference(
                  notificationType: AppDefaults.calendarNotificationType,
                  enabled: value,
                );
              },
              title: context.l10n.notificationsCalendarReminders,
              subtitle: state.permissionStatus.isGranted
                  ? (calendarRemindersEnabled
                        ? context.l10n.notificationsCalendarRemindersOn
                        : context.l10n.notificationsCalendarRemindersOff)
                  : context.l10n.notificationsCalendarRemindersNeedsPermission,
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 16),
              _DebugToolsCard(state: state),
            ],
          ];

          return ResponsiveContentLayout(
            builder: (context, isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CachedDataStatus(
                    isUsingCachedData: state.isUsingCachedData,
                  lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  AppBanner(
                    text: localizeUiError(context, state.error),
                    isError: true,
                  ),
                ],
                  const SizedBox(height: 12),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _IntroCard(
                                permissionStatus: state.permissionStatus,
                              ),
                              const SizedBox(height: 16),
                              _PermissionCard(state: state),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: reminderCards,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _IntroCard(permissionStatus: state.permissionStatus),
                    const SizedBox(height: 16),
                    _PermissionCard(state: state),
                    const SizedBox(height: 16),
                    ...reminderCards,
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  bool _preferenceEnabled(
    List<NotificationPreferenceDto> preferences,
    String notificationType,
  ) {
    return preferences.any(
      (preference) =>
          preference.notificationType == notificationType && preference.enabled,
    );
  }
}
