import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../notifications/domain/notification_models.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../providers/tasks_provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _titleController = TextEditingController();
  bool _isPersonal = false;
  bool _recurringOnComplete = false;
  DateTime? _dueAt;
  ReminderPreset _reminderPreset = ReminderPreset.none;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.isLoading && state.tasks.isEmpty) {
            return const LoadingState();
          }

          if (state.error != null && state.tasks.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<TasksCubit>().reload(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppTextField(controller: _titleController, label: 'Task title'),
              const SizedBox(height: 12),
              DateTimePickerField(
                label: 'Due at',
                value: _dueAt,
                onChanged: (value) => setState(() => _dueAt = value),
              ),
              const SizedBox(height: 12),
              ReminderPresetField(
                label: 'Reminder',
                value: _reminderPreset,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _reminderPreset = value);
                },
              ),
              SwitchListTile(
                value: _isPersonal,
                onChanged: (value) => setState(() => _isPersonal = value),
                title: const Text('Personal task'),
              ),
              SwitchListTile(
                value: _recurringOnComplete,
                onChanged: (value) =>
                    setState(() => _recurringOnComplete = value),
                title: const Text('Generate next on complete'),
              ),
              AppButton(
                label: 'Create task',
                isLoading: state.isLoading,
                onPressed: () async {
                  final tasksCubit = context.read<TasksCubit>();
                  final notificationsCubit = context.read<NotificationsCubit>();
                  final messenger = ScaffoldMessenger.of(context);
                  final title = _titleController.text.trim();
                  if (title.isEmpty) {
                    return;
                  }
                  if (_reminderPreset != ReminderPreset.none &&
                      _dueAt == null) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Set a due date to add a reminder.'),
                      ),
                    );
                    return;
                  }

                  final task = await tasksCubit.createTask(
                    title: title,
                    isPersonal: _isPersonal,
                    dueAt: _dueAt,
                    recurringOnComplete: _recurringOnComplete,
                  );
                  if (!mounted || task == null) {
                    return;
                  }

                  final remindAt = _dueAt == null
                      ? null
                      : _reminderPreset.scheduleAt(_dueAt!);
                  if (remindAt == null) {
                    return;
                  }

                  final result = await notificationsCubit.ensureReminder(
                    notificationType: AppDefaults.taskNotificationType,
                    entityType: AppDefaults.taskReminderEntityType,
                    entityId: task.id,
                    remindAt: remindAt,
                    payloadJson: jsonEncode({'taskId': task.id}),
                    title: 'Task reminder',
                    body: title,
                  );
                  if (!mounted || result.message == null) {
                    return;
                  }
                  messenger.showSnackBar(
                    SnackBar(content: Text(result.message!)),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (state.tasks.isEmpty)
                const EmptyState(
                  title: 'No tasks',
                  message: 'Create your first personal or shared task.',
                )
              else
                ...state.tasks.map(
                  (task) => AppTile(
                    title: task.title,
                    subtitle:
                        'Status: ${task.status}, Priority: ${task.priority}, Personal: ${task.isPersonal}',
                    trailing: Checkbox(
                      value: task.status == 'completed',
                      onChanged: task.status == 'completed'
                          ? null
                          : (_) async {
                              await context.read<TasksCubit>().complete(task);
                            },
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
