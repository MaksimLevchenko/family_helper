import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    _entityIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: 'Register push token',
                isLoading: state.isLoading,
                onPressed: () async {
                  await context.read<NotificationsCubit>().initPush();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Enable task notifications',
                onPressed: () async {
                  await context.read<NotificationsCubit>().setPreference(
                    notificationType: 'task',
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
                label: 'Schedule reminder',
                onPressed: () async {
                  final remindAt = _remindAt;
                  final entityId = int.tryParse(_entityIdController.text.trim());
                  if (remindAt == null || entityId == null) {
                    return;
                  }
                  await context.read<NotificationsCubit>().scheduleReminder(
                    entityType: 'task',
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
                  message: 'Schedule a reminder to test local and server flow.',
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
