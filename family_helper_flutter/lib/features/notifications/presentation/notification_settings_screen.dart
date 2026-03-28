import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
import '../domain/notification_models.dart';
import '../providers/notifications_provider.dart';

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
        title: const Text('Notification settings'),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CachedDataStatus(
                isUsingCachedData: state.isUsingCachedData,
                lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
              ),
              if (state.error != null) ...[
                const SizedBox(height: 12),
                AppBanner(text: state.error!, isError: true),
              ],
              const SizedBox(height: 12),
              _IntroCard(permissionStatus: state.permissionStatus),
              const SizedBox(height: 16),
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
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                _DebugToolsCard(state: state),
              ],
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

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.permissionStatus});

  final NotificationPermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tune how Family Helper reaches you',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            permissionStatus.summaryLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose which reminders stay active on this device and keep permission status in a healthy state.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
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

class _DebugToolsCard extends StatelessWidget {
  const _DebugToolsCard({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debug tools',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'Sends a real Firebase push through the server to this signed-in device.',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Send test push',
              isLoading: state.isLoading,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final result = await context
                    .read<NotificationsCubit>()
                    .scheduleDebugNotification();
                if (!context.mounted || result.message == null) {
                  return;
                }
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(result.message!)),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
