import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
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
      context.read<NotificationsCubit>().loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          NotificationPreferenceDto? taskPreference;
          for (final preference in state.preferences) {
            if (preference.notificationType ==
                AppDefaults.defaultNotificationType) {
              taskPreference = preference;
              break;
            }
          }
          final taskRemindersEnabled = taskPreference?.enabled ?? false;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              Card(
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
                        state.localNotificationsEnabled
                            ? 'Notifications are enabled for this device.'
                            : 'Enable notifications to receive family reminders.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: state.localNotificationsEnabled
                            ? 'Notifications enabled'
                            : 'Enable notifications',
                        isLoading: state.isLoading,
                        onPressed: () async {
                          await context
                              .read<NotificationsCubit>()
                              .initializeLocalReminders();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  value: taskRemindersEnabled,
                  onChanged: (value) async {
                    await context.read<NotificationsCubit>().setPreference(
                      notificationType: AppDefaults.defaultNotificationType,
                      enabled: value,
                    );
                  },
                  title: const Text('Task reminders'),
                  subtitle: Text(
                    taskRemindersEnabled
                        ? 'You will receive reminders for upcoming tasks.'
                        : 'Task reminders are currently turned off.',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
