import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../notifications/domain/notification_models.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _titleController = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  bool _isRecurringDaily = false;
  ReminderPreset _reminderPreset = ReminderPreset.none;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          if (state.isLoading && state.instances.isEmpty) {
            return const LoadingState();
          }

          if (state.error != null && state.instances.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<CalendarCubit>().reload(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppTextField(controller: _titleController, label: 'Event title'),
              const SizedBox(height: 12),
              DateTimePickerField(
                label: 'Starts at',
                value: _start,
                onChanged: (value) => setState(() => _start = value),
              ),
              const SizedBox(height: 12),
              DateTimePickerField(
                label: 'Ends at',
                value: _end,
                onChanged: (value) => setState(() => _end = value),
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
                value: _isRecurringDaily,
                onChanged: (value) => setState(() => _isRecurringDaily = value),
                title: const Text('Repeat daily'),
              ),
              AppButton(
                label: 'Create event',
                isLoading: state.isLoading,
                onPressed: () async {
                  final calendarCubit = context.read<CalendarCubit>();
                  final notificationsCubit = context.read<NotificationsCubit>();
                  final messenger = ScaffoldMessenger.of(context);
                  if (_titleController.text.trim().isEmpty ||
                      _start == null ||
                      _end == null) {
                    return;
                  }
                  final title = _titleController.text.trim();
                  final event = await calendarCubit.createEvent(
                    title: title,
                    startsAt: _start!,
                    endsAt: _end!,
                    rrule: _isRecurringDaily
                        ? AppDefaults.dailyRecurrenceRrule
                        : null,
                  );
                  if (!mounted || event == null) {
                    return;
                  }

                  final remindAt = _reminderPreset.scheduleAt(_start!);
                  if (remindAt == null) {
                    return;
                  }

                  final result = await notificationsCubit.ensureReminder(
                    notificationType: AppDefaults.calendarNotificationType,
                    entityType: AppDefaults.calendarReminderEntityType,
                    entityId: event.id,
                    remindAt: remindAt,
                    payloadJson: jsonEncode({
                      'eventId': event.id,
                      'startsAt': event.startsAt.toUtc().toIso8601String(),
                    }),
                    title: 'Event reminder',
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
              if (state.instances.isEmpty)
                const EmptyState(
                  title: 'No events',
                  message: 'Create a calendar event to see it here.',
                )
              else
                ...state.instances.map(
                  (instance) => AppTile(
                    title: instance.title,
                    subtitle:
                        '${instance.occurrenceStart.toLocal()} - ${instance.occurrenceEnd.toLocal()}${instance.cancelled ? ' (cancelled)' : ''}',
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: instance.cancelled
                          ? null
                          : () async {
                              await context
                                  .read<CalendarCubit>()
                                  .cancelOccurrence(instance);
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
