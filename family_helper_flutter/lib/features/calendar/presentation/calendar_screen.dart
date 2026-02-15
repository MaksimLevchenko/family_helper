import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui_kit/ui_kit.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarCubit>().reload();
    });
  }

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
              SwitchListTile(
                value: _isRecurringDaily,
                onChanged: (value) => setState(() => _isRecurringDaily = value),
                title: const Text('Repeat daily'),
              ),
              AppButton(
                label: 'Create event',
                isLoading: state.isLoading,
                onPressed: () async {
                  if (_titleController.text.trim().isEmpty || _start == null || _end == null) {
                    return;
                  }
                  await context.read<CalendarCubit>().createEvent(
                    title: _titleController.text.trim(),
                    startsAt: _start!,
                    endsAt: _end!,
                    rrule: _isRecurringDaily ? 'FREQ=DAILY;INTERVAL=1' : null,
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
                              await context.read<CalendarCubit>().cancelOccurrence(instance);
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
