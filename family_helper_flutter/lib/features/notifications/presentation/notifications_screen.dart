import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
import '../domain/notification_models.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
      appBar: AppBar(title: const Text('Notifications')),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              _PermissionCard(state: state),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  value: taskRemindersEnabled,
                  onChanged: (value) async {
                    await context.read<NotificationsCubit>().setPreference(
                      notificationType: AppDefaults.taskNotificationType,
                      enabled: value,
                    );
                  },
                  title: const Text('Task reminders'),
                  subtitle: Text(
                    state.permissionStatus.isGranted
                        ? (taskRemindersEnabled
                              ? 'You will receive reminders for upcoming tasks.'
                              : 'Task reminders are currently turned off.')
                        : 'Turn on device notifications to receive task reminders.',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: SwitchListTile(
                  value: calendarRemindersEnabled,
                  onChanged: (value) async {
                    await context.read<NotificationsCubit>().setPreference(
                      notificationType: AppDefaults.calendarNotificationType,
                      enabled: value,
                    );
                  },
                  title: const Text('Calendar reminders'),
                  subtitle: Text(
                    state.permissionStatus.isGranted
                        ? (calendarRemindersEnabled
                              ? 'You will receive reminders for upcoming events.'
                              : 'Calendar reminders are currently turned off.')
                        : 'Turn on device notifications to receive calendar reminders.',
                  ),
                ),
              ),
            ],
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

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    final showAction =
        state.permissionStatus != NotificationPermissionStatus.granted;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              state.permissionStatus.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (showAction)
              AppButton(
                label: state.permissionStatus.actionLabel,
                isLoading: state.isLoading,
                onPressed: () async {
                  final cubit = context.read<NotificationsCubit>();
                  if (state.permissionStatus ==
                      NotificationPermissionStatus.notDetermined) {
                    await cubit.requestSystemPermission();
                  } else {
                    await cubit.openSystemNotificationSettings();
                  }
                },
              )
            else
              const Text('Notifications enabled'),
          ],
        ),
      ),
    );
  }
}
