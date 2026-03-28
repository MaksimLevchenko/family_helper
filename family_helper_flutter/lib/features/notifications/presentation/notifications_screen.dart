import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
import '../data/notification_navigation_service.dart';
import '../data/push_notification_service.dart';
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
      cubit.reloadInbox();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Notifications')),
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
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              _PermissionCard(state: state),
              const SizedBox(height: 16),
              _InboxSection(state: state),
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

class _InboxSection extends StatelessWidget {
  const _InboxSection({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family inbox',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.unreadCount > 0
                            ? '${state.unreadCount} unread'
                            : 'Everything is read',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: state.inbox.isEmpty || state.unreadCount == 0
                      ? null
                      : () {
                          context
                              .read<NotificationsCubit>()
                              .markAllNotificationsRead();
                        },
                  child: const Text('Mark all read'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (state.inbox.isEmpty)
              const Text('New notifications for this family will appear here.')
            else
              ...state.inbox.map(
                (notification) => _NotificationTile(notification: notification),
              ),
            if (state.inboxHasMore) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<NotificationsCubit>().reloadInbox(
                      append: true,
                    );
                  },
                  child: const Text('Load more'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotificationDto notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: notification.isRead
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final cubit = context.read<NotificationsCubit>();
            if (!notification.isRead) {
              await cubit.markNotificationRead(notification.id);
            }
            if (!context.mounted) {
              return;
            }
            final target = NotificationOpenTarget.fromPayloadJson(
              notification.payloadJson,
            );
            if (target == null) {
              return;
            }
            await NotificationNavigationService.openTarget(context, target);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? theme.colorScheme.outline
                        : theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text(_categoryLabel(notification.category)),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text(_timestampLabel(context)),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _timestampLabel(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final createdAt = notification.createdAt.toLocal();
    final date = localizations.formatShortDate(createdAt);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(createdAt),
      alwaysUse24HourFormat: true,
    );
    return '$date, $time';
  }

  String _categoryLabel(String category) {
    return switch (category) {
      'due_reminder' => 'Reminder',
      'task_assigned' => 'Assigned task',
      'task_completed' => 'Completed task',
      'calendar_created' => 'Calendar update',
      'calendar_updated' => 'Calendar update',
      'calendar_cancelled' => 'Calendar cancelled',
      'family_invite_created' => 'Family invite',
      'family_invite_accepted' => 'Family update',
      _ => 'Notification',
    };
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
