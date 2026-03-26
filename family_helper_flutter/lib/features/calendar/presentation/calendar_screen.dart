import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../notifications/domain/notification_models.dart';
import '../domain/calendar_event_form.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openCreateEvent(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateEvent(context),
        icon: const Icon(Icons.event_available),
        label: const Text('Add event'),
      ),
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

          final cubit = context.read<CalendarCubit>();
          final agendaItems = cubit.agendaForDay(state.selectedDay);
          final groupedEvents = cubit.eventsByDay();

          return Column(
            children: [
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: AppBanner(text: state.error!, isError: true),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _CalendarMonthCard(
                  selectedDay: state.selectedDay,
                  visibleMonth: state.visibleMonth,
                  groupedEvents: groupedEvents,
                  isBusy: state.isLoading || state.isMutating,
                  onDaySelected: (day) {
                    context.read<CalendarCubit>().selectDay(day);
                  },
                  onPageChanged: (focusedDay) {
                    context.read<CalendarCubit>().setVisibleMonth(focusedDay);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _AgendaSection(
                    selectedDay: state.selectedDay,
                    items: agendaItems,
                    isMutating: state.isMutating,
                    onTapItem: (instance) =>
                        _openInstanceActions(context, instance),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openCreateEvent(BuildContext context) async {
    final cubit = context.read<CalendarCubit>();
    final initialForm = CalendarEventForm.createDefault(
      context.read<CalendarCubit>().state.selectedDay,
    );
    final form = await showModalBottomSheet<CalendarEventForm>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CalendarEventEditorSheet(
          title: 'Create event',
          submitLabel: 'Save event',
          initialForm: initialForm,
          allowRecurrence: true,
        );
      },
    );
    if (form == null || !context.mounted) {
      return;
    }
    await cubit.saveSeries(form: form);
  }

  Future<void> _openInstanceActions(
    BuildContext context,
    CalendarInstanceDto instance,
  ) async {
    final action = await showModalBottomSheet<_CalendarAction>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                title: Text(instance.title),
                subtitle: Text(_instanceTimeLabel(instance)),
              ),
              if (instance.isRecurring) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit this occurrence'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_CalendarAction.editOne),
                ),
                ListTile(
                  leading: const Icon(Icons.update_outlined),
                  title: const Text('Edit this and following'),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_CalendarAction.editFuture),
                ),
                ListTile(
                  leading: const Icon(Icons.auto_mode_outlined),
                  title: const Text('Edit whole series'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_CalendarAction.editAll),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete this occurrence'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_CalendarAction.deleteOne),
                ),
                ListTile(
                  leading: const Icon(Icons.event_busy_outlined),
                  title: const Text('Delete this and following'),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_CalendarAction.deleteFuture),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined),
                  title: const Text('Delete whole series'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_CalendarAction.deleteAll),
                ),
              ] else ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit event'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_CalendarAction.editAll),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete event'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_CalendarAction.deleteAll),
                ),
              ],
            ],
          ),
        );
      },
    );
    if (action == null || !context.mounted) {
      return;
    }

    switch (action) {
      case _CalendarAction.editOne:
        await _editOccurrence(context, instance);
        return;
      case _CalendarAction.editFuture:
        await _editSeries(
          context,
          instance,
          scope: CalendarMutationScope.future,
        );
        return;
      case _CalendarAction.editAll:
        await _editSeries(
          context,
          instance,
          scope: CalendarMutationScope.all,
        );
        return;
      case _CalendarAction.deleteOne:
        await _confirmDeleteOccurrence(context, instance);
        return;
      case _CalendarAction.deleteFuture:
        await _confirmDeleteSeries(
          context,
          instance,
          scope: CalendarMutationScope.future,
        );
        return;
      case _CalendarAction.deleteAll:
        await _confirmDeleteSeries(
          context,
          instance,
          scope: CalendarMutationScope.all,
        );
        return;
    }
  }

  Future<void> _editOccurrence(
    BuildContext context,
    CalendarInstanceDto instance,
  ) async {
    final cubit = context.read<CalendarCubit>();
    final form = await showModalBottomSheet<CalendarEventForm>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CalendarEventEditorSheet(
          title: 'Edit occurrence',
          submitLabel: 'Save changes',
          initialForm: CalendarEventForm.fromInstance(instance),
          allowRecurrence: false,
        );
      },
    );
    if (form == null || !context.mounted) {
      return;
    }
    await cubit.saveOccurrence(instance: instance, form: form);
  }

  Future<void> _editSeries(
    BuildContext context,
    CalendarInstanceDto instance, {
    required CalendarMutationScope scope,
  }) async {
    final cubit = context.read<CalendarCubit>();
    final event = await cubit.loadEvent(instance.eventId);
    if (!context.mounted) {
      return;
    }

    final initialForm = scope == CalendarMutationScope.future
        ? CalendarEventForm(
            title: event.title,
            description: event.description,
            startsAt: instance.occurrenceStart,
            endsAt: instance.occurrenceEnd,
            recurrence: CalendarRecurrence.fromRrule(
              event.rrule,
              event.startsAt,
            ),
            reminderPreset: CalendarEventForm.fromEvent(event).reminderPreset,
          )
        : CalendarEventForm.fromEvent(event);
    final title = scope == CalendarMutationScope.future
        ? 'Edit this and following'
        : 'Edit whole series';
    final form = await showModalBottomSheet<CalendarEventForm>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CalendarEventEditorSheet(
          title: title,
          submitLabel: 'Save changes',
          initialForm: initialForm,
          allowRecurrence: true,
        );
      },
    );
    if (form == null || !context.mounted) {
      return;
    }
    await cubit.saveSeries(
      form: form,
      eventId: event.id,
      scope: scope,
      anchorOccurrenceStart: scope == CalendarMutationScope.future
          ? instance.occurrenceKeyStart
          : null,
    );
  }

  Future<void> _confirmDeleteOccurrence(
    BuildContext context,
    CalendarInstanceDto instance,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: 'Delete occurrence',
          message: 'Only this occurrence will be removed.',
          confirmLabel: 'Delete',
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<CalendarCubit>().deleteOccurrence(instance);
  }

  Future<void> _confirmDeleteSeries(
    BuildContext context,
    CalendarInstanceDto instance, {
    required CalendarMutationScope scope,
  }) async {
    final message = scope == CalendarMutationScope.future
        ? 'This occurrence and all following ones will be removed.'
        : 'The whole series will be removed.';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: 'Delete event',
          message: message,
          confirmLabel: 'Delete',
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<CalendarCubit>().deleteSeries(
      instance: instance,
      scope: scope,
    );
  }

  static String _instanceTimeLabel(CalendarInstanceDto instance) {
    final start = instance.occurrenceStart.toLocal();
    final end = instance.occurrenceEnd.toLocal();
    return '${_twoDigits(start.hour)}:${_twoDigits(start.minute)} - ${_twoDigits(end.hour)}:${_twoDigits(end.minute)}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class _CalendarMonthCard extends StatelessWidget {
  const _CalendarMonthCard({
    required this.selectedDay,
    required this.visibleMonth,
    required this.groupedEvents,
    required this.isBusy,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime selectedDay;
  final DateTime visibleMonth;
  final Map<DateTime, List<CalendarInstanceDto>> groupedEvents;
  final bool isBusy;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          TableCalendar<CalendarInstanceDto>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: visibleMonth,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            eventLoader: (day) =>
                groupedEvents[DateTime(day.year, day.month, day.day)] ??
                const [],
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle:
                  Theme.of(context).textTheme.titleMedium ?? const TextStyle(),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              markerDecoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              todayDecoration: BoxDecoration(
                border: Border.all(color: colors.primary, width: 1.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selected, focused) {
              onDaySelected(selected);
            },
            onPageChanged: onPageChanged,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${events.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.background,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isBusy) const LinearProgressIndicator(minHeight: 2),
        ],
      ),
    );
  }
}

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.selectedDay,
    required this.items,
    required this.isMutating,
    required this.onTapItem,
  });

  final DateTime selectedDay;
  final List<CalendarInstanceDto> items;
  final bool isMutating;
  final ValueChanged<CalendarInstanceDto> onTapItem;

  @override
  Widget build(BuildContext context) {
    final title = '${selectedDay.day}.${selectedDay.month}.${selectedDay.year}';
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const Expanded(
            child: EmptyState(
              title: 'No events',
              message: 'Tap "Add event" to create something for this day.',
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (isMutating) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _AgendaCard(
                instance: item,
                onTap: () => onTapItem(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.instance,
    required this.onTap,
  });

  final CalendarInstanceDto instance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final start = instance.occurrenceStart.toLocal();
    final end = instance.occurrenceEnd.toLocal();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: instance.isException ? colors.secondary : colors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${_CalendarScreenTime.twoDigits(start.hour)}:${_CalendarScreenTime.twoDigits(start.minute)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instance.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_CalendarScreenTime.twoDigits(start.hour)}:${_CalendarScreenTime.twoDigits(start.minute)} - ${_CalendarScreenTime.twoDigits(end.hour)}:${_CalendarScreenTime.twoDigits(end.minute)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (instance.isRecurring) _InfoChip(label: 'Recurring'),
                        if (instance.isException) _InfoChip(label: 'Edited'),
                        if (instance.reminderOffsetMinutes != null)
                          _InfoChip(
                            label: _reminderLabel(
                              instance.reminderOffsetMinutes!,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  String _reminderLabel(int offsetMinutes) {
    return switch (offsetMinutes) {
      0 => 'Reminder at time',
      10 => 'Reminder 10m before',
      60 => 'Reminder 1h before',
      1440 => 'Reminder 1d before',
      _ => 'Reminder',
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

class _CalendarEventEditorSheet extends StatefulWidget {
  const _CalendarEventEditorSheet({
    required this.title,
    required this.submitLabel,
    required this.initialForm,
    required this.allowRecurrence,
  });

  final String title;
  final String submitLabel;
  final CalendarEventForm initialForm;
  final bool allowRecurrence;

  @override
  State<_CalendarEventEditorSheet> createState() =>
      _CalendarEventEditorSheetState();
}

class _CalendarEventEditorSheetState extends State<_CalendarEventEditorSheet> {
  late final TextEditingController _titleController;
  late DateTime _startsAt;
  late DateTime _endsAt;
  late CalendarRecurrence _recurrence;
  late ReminderPreset _reminderPreset;
  late final TextEditingController _intervalController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialForm.title);
    _startsAt = widget.initialForm.startsAt;
    _endsAt = widget.initialForm.endsAt;
    _recurrence = widget.initialForm.recurrence;
    _reminderPreset = widget.initialForm.reminderPreset;
    _intervalController = TextEditingController(
      text: widget.initialForm.recurrence.interval.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            AppTextField(controller: _titleController, label: 'Event title'),
            const SizedBox(height: 12),
            DateTimePickerField(
              label: 'Starts at',
              value: _startsAt,
              onChanged: (value) => setState(() => _startsAt = value),
            ),
            const SizedBox(height: 12),
            DateTimePickerField(
              label: 'Ends at',
              value: _endsAt,
              onChanged: (value) => setState(() => _endsAt = value),
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
            if (widget.allowRecurrence) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<CalendarRecurrenceMode>(
                initialValue: _recurrence.mode,
                decoration: const InputDecoration(labelText: 'Repeat'),
                items: const [
                  DropdownMenuItem(
                    value: CalendarRecurrenceMode.none,
                    child: Text('Does not repeat'),
                  ),
                  DropdownMenuItem(
                    value: CalendarRecurrenceMode.yearly,
                    child: Text('Every year on this day'),
                  ),
                  DropdownMenuItem(
                    value: CalendarRecurrenceMode.monthly,
                    child: Text('Every month on this day'),
                  ),
                  DropdownMenuItem(
                    value: CalendarRecurrenceMode.weekly,
                    child: Text('Selected weekdays'),
                  ),
                  DropdownMenuItem(
                    value: CalendarRecurrenceMode.everyNDays,
                    child: Text('Every N days'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode == null) {
                    return;
                  }
                  setState(() {
                    _recurrence = switch (mode) {
                      CalendarRecurrenceMode.none =>
                        const CalendarRecurrence.none(),
                      CalendarRecurrenceMode.yearly =>
                        CalendarRecurrence.yearly(),
                      CalendarRecurrenceMode.monthly =>
                        CalendarRecurrence.monthly(),
                      CalendarRecurrenceMode.weekly =>
                        CalendarRecurrence.weekly(<int>{
                          _startsAt.toLocal().weekday,
                        }),
                      CalendarRecurrenceMode.everyNDays =>
                        CalendarRecurrence.everyNDays(
                          int.tryParse(_intervalController.text) ?? 1,
                        ),
                    };
                  });
                },
              ),
              if (_recurrence.mode == CalendarRecurrenceMode.weekly) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(7, (index) {
                    final weekday = index + 1;
                    final selected = _recurrence.weekdays.contains(weekday);
                    return FilterChip(
                      label: Text(_weekdayShortLabel(weekday)),
                      selected: selected,
                      onSelected: (value) {
                        final next = {..._recurrence.weekdays};
                        if (value) {
                          next.add(weekday);
                        } else {
                          next.remove(weekday);
                        }
                        setState(() {
                          _recurrence = CalendarRecurrence.weekly(
                            next.isEmpty ? <int>{weekday} : next,
                          );
                        });
                      },
                    );
                  }),
                ),
              ],
              if (_recurrence.mode == CalendarRecurrenceMode.everyNDays) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _intervalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Repeat every N days',
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: widget.submitLabel,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty || !_endsAt.isAfter(_startsAt)) {
      return;
    }

    var recurrence = _recurrence;
    if (recurrence.mode == CalendarRecurrenceMode.everyNDays) {
      recurrence = CalendarRecurrence.everyNDays(
        int.tryParse(_intervalController.text) ?? 1,
      );
    }

    Navigator.of(context).pop(
      CalendarEventForm(
        title: title,
        startsAt: _startsAt,
        endsAt: _endsAt,
        recurrence: recurrence,
        reminderPreset: _reminderPreset,
      ),
    );
  }

  String _weekdayShortLabel(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Mon',
      DateTime.tuesday => 'Tue',
      DateTime.wednesday => 'Wed',
      DateTime.thursday => 'Thu',
      DateTime.friday => 'Fri',
      DateTime.saturday => 'Sat',
      DateTime.sunday => 'Sun',
      _ => 'Day',
    };
  }
}

enum _CalendarAction {
  editOne,
  editFuture,
  editAll,
  deleteOne,
  deleteFuture,
  deleteAll,
}

class _CalendarScreenTime {
  static String twoDigits(int value) => value.toString().padLeft(2, '0');
}
