import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  DateTime? _remindAt;
  final _entityIdController = TextEditingController(text: '1');
  final _pushTokenController = TextEditingController();

  @override
  void dispose() {
    _entityIdController.dispose();
    _pushTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final pushToken = state.lastRegisteredPushToken;
          if (pushToken != null && _pushTokenController.text != pushToken) {
            _pushTokenController.text = pushToken;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: state.localNotificationsEnabled
                    ? 'Local notifications are enabled'
                    : 'Enable local notifications',
                isLoading: state.isLoading,
                onPressed: () async {
                  await context
                      .read<NotificationsCubit>()
                      .initializeLocalReminders();
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _pushTokenController,
                label: 'Push token',
                hint: 'Auto-generated on initialization',
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Register push token',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  final token = _pushTokenController.text.trim();
                  if (token.isEmpty) {
                    return;
                  }
                  await context.read<NotificationsCubit>().registerPushToken(
                    token: token,
                  );
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Enable task notifications',
                onPressed: () async {
                  await context.read<NotificationsCubit>().setPreference(
                    notificationType: AppDefaults.defaultNotificationType,
                    enabled: true,
                  );
                },
                variant: AppButtonVariant.secondary,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _entityIdController,
                label: 'Entity ID',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DateTimePickerField(
                label: 'Remind at',
                value: _remindAt,
                onChanged: (value) => setState(() => _remindAt = value),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Reload reminders',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await context.read<NotificationsCubit>().reloadReminders();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Schedule reminder',
                onPressed: () async {
                  final remindAt = _remindAt;
                  final entityId = int.tryParse(
                    _entityIdController.text.trim(),
                  );
                  if (remindAt == null || entityId == null) {
                    return;
                  }
                  await context.read<NotificationsCubit>().scheduleReminder(
                    entityType: AppDefaults.defaultReminderEntityType,
                    entityId: entityId,
                    remindAt: remindAt,
                    payloadJson: '{"entityId":$entityId}',
                  );
                },
              ),
              const SizedBox(height: 24),
              if (state.reminders.isEmpty)
                const EmptyState(
                  title: 'No reminders',
                  message: 'No active reminders for the selected family.',
                )
              else
                ...state.reminders.map(
                  (reminder) => AppTile(
                    title: 'Reminder #${reminder.id}',
                    subtitle:
                        '${reminder.entityType}:${reminder.entityId} at ${reminder.remindAt.toLocal()} (${reminder.status})',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
