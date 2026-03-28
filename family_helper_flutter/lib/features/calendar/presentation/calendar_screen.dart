import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/network/server_availability_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../notifications/domain/notification_models.dart';
import '../domain/calendar_event_form.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static const double _wideLayoutBreakpoint = 720;
  static const double _maxWidthBreakpoint = 1100;
  static const double _maxContentWidth = 1280;
  static const double _monthPaneWidth = 440;

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Calendar')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isOffline ? null : () => _openCreateEvent(context),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('Add event'),
      ),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listenWhen: (previous, current) =>
            previous.error != current.error &&
            current.error != null &&
            current.errorFromMutation,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        },
        builder: (context, state) {
          if (state.isInitialLoading && state.instances.isEmpty) {
            return const LoadingState(label: 'Loading your calendar...');
          }

          if (state.error != null &&
              !state.errorFromMutation &&
              state.instances.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<CalendarCubit>().reload(),
            );
          }

          final cubit = context.read<CalendarCubit>();
          final agendaItems = cubit.agendaForDay(state.selectedDay);
          final groupedEvents = cubit.eventsByDay();
          final colors = context.colors;

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.background,
                  colors.surfaceMuted.withValues(alpha: 0.42),
                  colors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
                  final maxWidth = constraints.maxWidth >= _maxWidthBreakpoint
                      ? _maxContentWidth
                      : double.infinity;

                  final statusWidgets = <Widget>[
                    if (isOffline &&
                        state.isUsingCachedData &&
                        state.lastSuccessfulSyncAt != null)
                      CachedDataStatus(
                        isUsingCachedData: state.isUsingCachedData,
                        lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
                      ),
                    if (state.error != null && !state.errorFromMutation)
                      AppBanner(text: state.error!, isError: true),
                  ];

                  final monthCard = _CalendarMonthCard(
                    selectedDay: state.selectedDay,
                    visibleMonth: state.visibleMonth,
                    groupedEvents: groupedEvents,
                    selectedAgendaItems: agendaItems,
                    isRefreshing: state.isMonthTransitioning,
                    onDaySelected: (day) {
                      context.read<CalendarCubit>().selectDay(day);
                    },
                    onPageChanged: (focusedDay) {
                      context.read<CalendarCubit>().setVisibleMonth(
                        focusedDay,
                      );
                    },
                  );

                  final agendaSection = _AgendaSection(
                    selectedDay: state.selectedDay,
                    items: agendaItems,
                    isRefreshing: state.isMonthTransitioning,
                    isMutating: state.isMutating,
                    isPendingItem: state.isPendingInstance,
                    onTapItem: (instance) {
                      if (isOffline) {
                        _showOfflineMessage(context);
                        return;
                      }
                      _openInstanceActions(context, instance);
                    },
                    onCreateEvent: () {
                      if (isOffline) {
                        _showOfflineMessage(context);
                        return;
                      }
                      _openCreateEvent(context);
                    },
                  );

                  final body = isWide
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            key: const Key('calendar-wide-layout'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ..._withGaps(statusWidgets, gap: 12),
                              if (statusWidgets.isNotEmpty)
                                const SizedBox(height: 16),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      key: const Key('calendar-month-pane'),
                                      width: _monthPaneWidth,
                                      child: SingleChildScrollView(
                                        child: monthCard,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        key: const Key('calendar-agenda-pane'),
                                        child: agendaSection,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          key: const Key('calendar-narrow-layout'),
                          padding: const EdgeInsets.only(bottom: 96),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              children: [
                                if (statusWidgets.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      16,
                                      16,
                                      0,
                                    ),
                                    child: Column(
                                      children: _withGaps(
                                        statusWidgets,
                                        gap: 12,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    12,
                                  ),
                                  child: monthCard,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: agendaSection,
                                ),
                              ],
                            ),
                          ),
                        );

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: body,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openCreateEvent(BuildContext context) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final cubit = context.read<CalendarCubit>();
    final initialForm = CalendarEventForm.createDefault(
      context.read<CalendarCubit>().state.selectedDay,
    );
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: 'Create event',
        submitLabel: 'Save event',
        initialForm: initialForm,
        allowRecurrence: true,
        useModalShell: useModalShell,
      ),
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
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final action = await _showAdaptiveOverlay<_CalendarAction>(
      context,
      maxWidth: 560,
      builder: (overlayContext, useModalShell) => _CalendarActionSheet(
        instance: instance,
        useModalShell: useModalShell,
      ),
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
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final cubit = context.read<CalendarCubit>();
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: 'Edit occurrence',
        submitLabel: 'Save changes',
        initialForm: CalendarEventForm.fromInstance(instance),
        allowRecurrence: false,
        useModalShell: useModalShell,
      ),
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
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
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
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: title,
        submitLabel: 'Save changes',
        initialForm: initialForm,
        allowRecurrence: true,
        useModalShell: useModalShell,
      ),
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
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
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
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
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

  Future<T?> _showAdaptiveOverlay<T>(
    BuildContext context, {
    required Widget Function(BuildContext context, bool useModalShell) builder,
    required double maxWidth,
  }) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideLayoutBreakpoint;
    if (isWide) {
      return showDialog<T>(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            insetPadding: const EdgeInsets.all(24),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.9,
              ),
              child: builder(dialogContext, false),
            ),
          );
        },
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => builder(sheetContext, true),
    );
  }

  List<Widget> _withGaps(List<Widget> widgets, {required double gap}) {
    final spaced = <Widget>[];
    for (var index = 0; index < widgets.length; index++) {
      if (index > 0) {
        spaced.add(SizedBox(height: gap));
      }
      spaced.add(widgets[index]);
    }
    return spaced;
  }

  void _showOfflineMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Server unavailable. This action will work again when connection is restored.',
        ),
      ),
    );
  }
}

class _CalendarMonthCard extends StatelessWidget {
  const _CalendarMonthCard({
    required this.selectedDay,
    required this.visibleMonth,
    required this.groupedEvents,
    required this.selectedAgendaItems,
    required this.isRefreshing,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime selectedDay;
  final DateTime visibleMonth;
  final Map<DateTime, List<CalendarInstanceDto>> groupedEvents;
  final List<CalendarInstanceDto> selectedAgendaItems;
  final bool isRefreshing;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final firstUpcoming = selectedAgendaItems.isEmpty
        ? null
        : (selectedAgendaItems.toList()..sort(
                (left, right) => left.occurrenceStart.compareTo(
                  right.occurrenceStart,
                ),
              ))
              .first;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surface.withValues(alpha: 0.98),
            colors.surfaceMuted.withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.border.withValues(alpha: 0.88)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your schedule',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _CalendarFormatters.fullDate(selectedDay),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRefreshing) const _BusyPill(label: 'Updating'),
              ],
            ),
            const SizedBox(height: 16),
            _SelectedDaySummaryCard(
              selectedDay: selectedDay,
              firstUpcoming: firstUpcoming,
              itemCount: selectedAgendaItems.length,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _CalendarFormatters.monthLabel(visibleMonth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _MonthNavButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => onPageChanged(
                    DateTime(visibleMonth.year, visibleMonth.month - 1, 1),
                  ),
                ),
                const SizedBox(width: 8),
                _MonthNavButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => onPageChanged(
                    DateTime(visibleMonth.year, visibleMonth.month + 1, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: isRefreshing ? 0.76 : 1,
              child: TableCalendar<CalendarInstanceDto>(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: visibleMonth,
                headerVisible: false,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                eventLoader: (day) =>
                    groupedEvents[DateTime(day.year, day.month, day.day)] ??
                    const [],
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: true,
                  isTodayHighlighted: false,
                  cellMargin: EdgeInsets.all(3),
                  defaultDecoration: BoxDecoration(),
                  selectedDecoration: BoxDecoration(),
                  todayDecoration: BoxDecoration(),
                ),
                daysOfWeekHeight: 26,
                rowHeight: 58,
                onDaySelected: (selected, _) => onDaySelected(selected),
                onPageChanged: onPageChanged,
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    return Center(
                      child: Text(
                        _CalendarFormatters.weekdayCompact(day.weekday),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, _) => _calendarDayCell(day),
                  outsideBuilder: (context, day, _) =>
                      _calendarDayCell(day, isOutside: true),
                  todayBuilder: (context, day, _) =>
                      _calendarDayCell(day, isToday: true),
                  selectedBuilder: (context, day, _) =>
                      _calendarDayCell(day, isSelected: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarDayCell(
    DateTime day, {
    bool isSelected = false,
    bool isToday = false,
    bool isOutside = false,
  }) {
    return _CalendarDayCell(
      day: day,
      eventCount:
          groupedEvents[DateTime(day.year, day.month, day.day)]?.length ?? 0,
      isSelected: isSelected,
      isToday: isToday,
      isOutside: isOutside,
    );
  }
}

class _SelectedDaySummaryCard extends StatelessWidget {
  const _SelectedDaySummaryCard({
    required this.selectedDay,
    required this.firstUpcoming,
    required this.itemCount,
  });

  final DateTime selectedDay;
  final CalendarInstanceDto? firstUpcoming;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final hasItems = itemCount > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border.withValues(alpha: 0.84)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              hasItems
                  ? Icons.event_note_rounded
                  : Icons.calendar_today_rounded,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasItems ? '$itemCount plans for this day' : 'Open day',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasItems
                      ? 'Next: ${_CalendarFormatters.timeRange(firstUpcoming!.occurrenceStart, firstUpcoming!.occurrenceEnd)} • ${firstUpcoming!.title}'
                      : 'Nothing is scheduled yet. Add an event to keep the day organized.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.background.withValues(alpha: 0.72),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.eventCount,
    this.isSelected = false,
    this.isToday = false,
    this.isOutside = false,
  });

  final DateTime day;
  final int eventCount;
  final bool isSelected;
  final bool isToday;
  final bool isOutside;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? colors.primary
        : isToday
        ? colors.border
        : Colors.transparent;
    final background = isSelected
        ? colors.primary.withValues(alpha: 0.14)
        : isToday
        ? colors.background.withValues(alpha: 0.75)
        : Colors.transparent;
    final textColor = isSelected
        ? colors.primary
        : isOutside
        ? colors.textSecondary.withValues(alpha: 0.55)
        : colors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isSelected || isToday ? FontWeight.w700 : null,
            ),
          ),
          const SizedBox(height: 6),
          _DayMarkers(eventCount: eventCount, isSelected: isSelected),
        ],
      ),
    );
  }
}

class _DayMarkers extends StatelessWidget {
  const _DayMarkers({
    required this.eventCount,
    required this.isSelected,
  });

  final int eventCount;
  final bool isSelected;
  static const _maxDotCount = 3;
  static const _countBadgeThreshold = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (eventCount == 0) {
      return const SizedBox(height: 12);
    }

    final dotColor = isSelected ? colors.primary : colors.secondary;
    if (eventCount >= _countBadgeThreshold) {
      final badgeLabel = eventCount > 99 ? '99+' : '$eventCount';
      final badgeBackground = dotColor.withValues(
        alpha: isSelected ? 0.18 : 0.14,
      );

      return Container(
        height: 14,
        constraints: const BoxConstraints(minWidth: 18, maxWidth: 30),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: badgeBackground,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: dotColor.withValues(alpha: 0.28)),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            badgeLabel,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: dotColor,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
      );
    }

    final visibleDots = eventCount > _maxDotCount ? _maxDotCount : eventCount;

    return SizedBox(
      height: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            visibleDots,
            (index) => Container(
              width: 6,
              height: 6,
              margin: EdgeInsets.only(right: index == visibleDots - 1 ? 0 : 4),
              decoration: BoxDecoration(
                color: dotColor.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.selectedDay,
    required this.items,
    required this.isRefreshing,
    required this.isMutating,
    required this.isPendingItem,
    required this.onTapItem,
    required this.onCreateEvent,
  });

  final DateTime selectedDay;
  final List<CalendarInstanceDto> items;
  final bool isRefreshing;
  final bool isMutating;
  final bool Function(CalendarInstanceDto instance) isPendingItem;
  final ValueChanged<CalendarInstanceDto> onTapItem;
  final VoidCallback onCreateEvent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final countLabel = items.length == 1 ? '1 event' : '${items.length} events';

    return Container(
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day agenda',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _CalendarFormatters.fullDate(selectedDay),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRefreshing) ...[
                  const SizedBox(width: 12),
                  const _BusyPill(label: 'Refreshing'),
                ],
                if (isMutating && !isRefreshing) ...[
                  const SizedBox(width: 12),
                  const _BusyPill(label: 'Saving'),
                ],
                const SizedBox(width: 12),
                _CountBadge(label: countLabel),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _AgendaEmptyState(onCreateEvent: onCreateEvent),
            )
          else
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: isRefreshing ? 0.76 : 1,
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 4),
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _AgendaCard(
                    instance: item,
                    isPending: isPendingItem(item),
                    onTap: () => onTapItem(item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AgendaEmptyState extends StatelessWidget {
  const _AgendaEmptyState({required this.onCreateEvent});

  final VoidCallback onCreateEvent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.border.withValues(alpha: 0.84)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.event_available_rounded,
                color: colors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing planned yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create an event for this day and it will appear here with the right repeat and reminder settings.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 180,
              child: AppButton(label: 'Add event', onPressed: onCreateEvent),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.instance,
    required this.isPending,
    required this.onTap,
  });

  final CalendarInstanceDto instance;
  final bool isPending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final start = instance.occurrenceStart.toLocal();
    final end = instance.occurrenceEnd.toLocal();
    final accentColor = instance.isException
        ? colors.secondary
        : colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isPending ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.surface.withValues(alpha: 0.97),
                colors.background.withValues(alpha: 0.92),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border.withValues(alpha: 0.88)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isPending ? 0.76 : 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TimeBlock(start: start, end: end),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                instance.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _CalendarFormatters.timeRange(
                            instance.occurrenceStart,
                            instance.occurrenceEnd,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (instance.isRecurring)
                              const _InfoChip(
                                label: 'Repeats',
                                icon: Icons.repeat_rounded,
                              ),
                            if (instance.isException)
                              const _InfoChip(
                                label: 'Edited',
                                icon: Icons.edit_calendar_rounded,
                              ),
                            if (instance.reminderOffsetMinutes != null)
                              _InfoChip(
                                label: _reminderLabel(
                                  instance.reminderOffsetMinutes!,
                                ),
                                icon: Icons.notifications_active_outlined,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 36,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: isPending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              Icons.more_horiz_rounded,
                              color: colors.textSecondary,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _reminderLabel(int offsetMinutes) {
    return switch (offsetMinutes) {
      0 => 'At time',
      10 => '10m before',
      60 => '1h before',
      1440 => '1d before',
      _ => 'Reminder',
    };
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceMuted.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _CalendarFormatters.timeOfDay(start),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _CalendarFormatters.timeOfDay(end),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _CalendarFormatters.durationLabel(start, end),
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BusyPill extends StatelessWidget {
  const _BusyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border.withValues(alpha: 0.84)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarActionSheet extends StatelessWidget {
  const _CalendarActionSheet({
    required this.instance,
    this.useModalShell = true,
  });

  final CalendarInstanceDto instance;
  final bool useModalShell;

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      useModalShell: useModalShell,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            instance.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            _CalendarFormatters.timeRange(
              instance.occurrenceStart,
              instance.occurrenceEnd,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          _SheetSection(
            title: 'Edit',
            children: instance.isRecurring
                ? [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit this occurrence',
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editOne),
                    ),
                    _ActionTile(
                      icon: Icons.update_outlined,
                      title: 'Edit this and following',
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editFuture),
                    ),
                    _ActionTile(
                      icon: Icons.auto_mode_outlined,
                      title: 'Edit whole series',
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editAll),
                    ),
                  ]
                : [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit event',
                      onTap: () =>
                          Navigator.of(context).pop(_CalendarAction.editAll),
                    ),
                  ],
          ),
          const SizedBox(height: 14),
          _SheetSection(
            title: 'Delete',
            children: instance.isRecurring
                ? [
                    _ActionTile(
                      icon: Icons.delete_outline,
                      title: 'Delete this occurrence',
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteOne),
                    ),
                    _ActionTile(
                      icon: Icons.event_busy_outlined,
                      title: 'Delete this and following',
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteFuture),
                    ),
                    _ActionTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'Delete whole series',
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteAll),
                    ),
                  ]
                : [
                    _ActionTile(
                      icon: Icons.delete_outline,
                      title: 'Delete event',
                      destructive: true,
                      onTap: () =>
                          Navigator.of(context).pop(_CalendarAction.deleteAll),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

class _SheetSection extends StatelessWidget {
  const _SheetSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.background.withValues(alpha: 0.66),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border.withValues(alpha: 0.84)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = destructive ? colors.danger : colors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: foreground),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

class _CalendarEventEditorSheet extends StatefulWidget {
  const _CalendarEventEditorSheet({
    required this.title,
    required this.submitLabel,
    required this.initialForm,
    required this.allowRecurrence,
    this.useModalShell = true,
  });

  final String title;
  final String submitLabel;
  final CalendarEventForm initialForm;
  final bool allowRecurrence;
  final bool useModalShell;

  @override
  State<_CalendarEventEditorSheet> createState() =>
      _CalendarEventEditorSheetState();
}

class _CalendarEventEditorSheetState extends State<_CalendarEventEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _intervalController;
  late DateTime _startsAt;
  late DateTime _endsAt;
  late CalendarRecurrence _recurrence;
  late ReminderPreset _reminderPreset;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialForm.title);
    _descriptionController = TextEditingController(
      text: widget.initialForm.description ?? '',
    );
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
    _descriptionController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);
    final colors = context.colors;
    final bottomPadding = widget.useModalShell ? safeArea.bottom : 0.0;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.useModalShell) ...[
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.allowRecurrence
                          ? 'Set time, reminders, and repeat rules in one place.'
                          : 'Update this single occurrence without changing the full series.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.border.withValues(alpha: 0.9)),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16 + bottomPadding),
            child: Column(
              children: [
                _EditorSection(
                  title: 'Basics',
                  subtitle:
                      'A clear title helps the whole family scan the day faster.',
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'Event title',
                      ),
                      if (widget.allowRecurrence) ...[
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _descriptionController,
                          label: 'Notes',
                          hint: 'Optional',
                          maxLines: 3,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditorSection(
                  title: 'Schedule',
                  subtitle:
                      'Choose a polished start and end time for the event.',
                  child: Column(
                    children: [
                      _DateTimeTile(
                        label: 'Starts',
                        value: _startsAt,
                        icon: Icons.login_rounded,
                        onTap: () => _pickDateTime(
                          initialValue: _startsAt,
                          onChanged: (value) {
                            final duration = _endsAt.difference(_startsAt);
                            setState(() {
                              _startsAt = value;
                              if (!_endsAt.isAfter(_startsAt)) {
                                _endsAt = _startsAt.add(
                                  duration.isNegative ||
                                          duration == Duration.zero
                                      ? const Duration(hours: 1)
                                      : duration,
                                );
                              }
                              _validationMessage = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DateTimeTile(
                        label: 'Ends',
                        value: _endsAt,
                        icon: Icons.logout_rounded,
                        onTap: () => _pickDateTime(
                          initialValue: _endsAt,
                          onChanged: (value) {
                            setState(() {
                              _endsAt = value;
                              _validationMessage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditorSection(
                  title: 'Reminder',
                  subtitle:
                      'Notifications should appear only when they are helpful.',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ReminderPreset.values
                        .map(
                          (preset) => _ChoicePill(
                            label: preset.label,
                            selected: _reminderPreset == preset,
                            onTap: () {
                              setState(() {
                                _reminderPreset = preset;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (widget.allowRecurrence) ...[
                  const SizedBox(height: 16),
                  _EditorSection(
                    title: 'Repeat',
                    subtitle:
                        'Keep repeat rules visible and only reveal the controls that matter.',
                    child: Column(
                      children: [
                        ...CalendarRecurrenceMode.values.map((mode) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RecurrenceModeTile(
                              mode: mode,
                              selected: _recurrence.mode == mode,
                              onTap: () => _selectRecurrenceMode(mode),
                            ),
                          );
                        }),
                        if (_recurrence.mode ==
                            CalendarRecurrenceMode.weekly) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Days of week',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(7, (index) {
                              final weekday = index + 1;
                              final selected = _recurrence.weekdays.contains(
                                weekday,
                              );
                              return _ChoicePill(
                                label: _CalendarFormatters.weekdayShort(
                                  weekday,
                                ),
                                selected: selected,
                                onTap: () {
                                  final next = {..._recurrence.weekdays};
                                  if (selected) {
                                    next.remove(weekday);
                                  } else {
                                    next.add(weekday);
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
                        if (_recurrence.mode ==
                            CalendarRecurrenceMode.everyNDays) ...[
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _intervalController,
                            label: 'Repeat every N days',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            border: Border(
              top: BorderSide(color: colors.border.withValues(alpha: 0.9)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + bottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_validationMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _validationMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.danger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
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
        ),
      ],
    );

    if (widget.useModalShell) {
      return AppModalSheet(
        maxWidth: 720,
        showHandle: false,
        scrollable: false,
        includeBottomSafeArea: false,
        contentPadding: EdgeInsets.zero,
        child: content,
      );
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.82,
      child: content,
    );
  }

  Future<void> _pickDateTime({
    required DateTime initialValue,
    required ValueChanged<DateTime> onChanged,
  }) async {
    final localInitial = initialValue.toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: localInitial,
      firstDate: DateTime(localInitial.year - 5),
      lastDate: DateTime(localInitial.year + 10),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(localInitial),
    );
    if (time == null) {
      return;
    }
    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute).toUtc(),
    );
  }

  void _selectRecurrenceMode(CalendarRecurrenceMode mode) {
    setState(() {
      _validationMessage = null;
      _recurrence = switch (mode) {
        CalendarRecurrenceMode.none => const CalendarRecurrence.none(),
        CalendarRecurrenceMode.yearly => CalendarRecurrence.yearly(),
        CalendarRecurrenceMode.monthly => CalendarRecurrence.monthly(),
        CalendarRecurrenceMode.weekly => CalendarRecurrence.weekly(
          <int>{_startsAt.toLocal().weekday},
        ),
        CalendarRecurrenceMode.everyNDays => CalendarRecurrence.everyNDays(
          int.tryParse(_intervalController.text) ?? 1,
        ),
      };
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _validationMessage = 'Please add an event title.';
      });
      return;
    }
    if (!_endsAt.isAfter(_startsAt)) {
      setState(() {
        _validationMessage = 'End time must be after the start time.';
      });
      return;
    }

    var recurrence = _recurrence;
    if (recurrence.mode == CalendarRecurrenceMode.everyNDays) {
      final interval = int.tryParse(_intervalController.text);
      if (interval == null || interval < 1) {
        setState(() {
          _validationMessage = 'Repeat interval should be at least 1 day.';
        });
        return;
      }
      recurrence = CalendarRecurrence.everyNDays(interval);
    }

    Navigator.of(context).pop(
      CalendarEventForm(
        title: title,
        description: widget.allowRecurrence
            ? (_descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim())
            : widget.initialForm.description,
        startsAt: _startsAt,
        endsAt: _endsAt,
        recurrence: recurrence,
        reminderPreset: _reminderPreset,
      ),
    );
  }
}

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border.withValues(alpha: 0.84)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.background.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _CalendarFormatters.dateTimeLabel(value),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.12)
              : colors.background.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? colors.primary
                : colors.border.withValues(alpha: 0.84),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RecurrenceModeTile extends StatelessWidget {
  const _RecurrenceModeTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final CalendarRecurrenceMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.10)
          : colors.background.withValues(alpha: 0.68),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.border.withValues(alpha: 0.84),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _modeIcon(mode),
                color: selected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _modeTitle(mode),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _modeSubtitle(mode),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? colors.primary : colors.border,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? colors.primary : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _modeIcon(CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none => Icons.block_rounded,
      CalendarRecurrenceMode.yearly => Icons.event_repeat_rounded,
      CalendarRecurrenceMode.monthly => Icons.calendar_view_month_rounded,
      CalendarRecurrenceMode.weekly => Icons.view_week_rounded,
      CalendarRecurrenceMode.everyNDays => Icons.loop_rounded,
    };
  }

  String _modeTitle(CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none => 'Does not repeat',
      CalendarRecurrenceMode.yearly => 'Every year on this day',
      CalendarRecurrenceMode.monthly => 'Every month on this day',
      CalendarRecurrenceMode.weekly => 'Selected weekdays',
      CalendarRecurrenceMode.everyNDays => 'Every N days',
    };
  }

  String _modeSubtitle(CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none => 'One-time event.',
      CalendarRecurrenceMode.yearly =>
        'Useful for birthdays and anniversaries.',
      CalendarRecurrenceMode.monthly =>
        'Runs on the same day number every month.',
      CalendarRecurrenceMode.weekly => 'Choose one or several weekdays.',
      CalendarRecurrenceMode.everyNDays =>
        'Great for routines with a fixed interval.',
    };
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({
    required this.child,
    this.useModalShell = true,
  });

  final Widget child;
  final bool useModalShell;

  @override
  Widget build(BuildContext context) {
    if (useModalShell) {
      return AppModalSheet(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: child,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: child,
    );
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

class _CalendarFormatters {
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdayShortNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _weekdayCompactNames = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  static String fullDate(DateTime date) {
    final local = date.toLocal();
    return '${_monthNames[local.month - 1]} ${local.day}, ${local.year}';
  }

  static String monthLabel(DateTime date) {
    final local = date.toLocal();
    return '${_monthNames[local.month - 1]} ${local.year}';
  }

  static String timeOfDay(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  }

  static String timeRange(DateTime start, DateTime end) {
    return '${timeOfDay(start)} - ${timeOfDay(end)}';
  }

  static String dateTimeLabel(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${_monthNames[local.month - 1]} ${local.day}, ${local.year} • ${timeOfDay(local)}';
  }

  static String durationLabel(DateTime start, DateTime end) {
    final difference = end.difference(start);
    if (difference.inHours >= 1) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}m';
    }
    return '${difference.inMinutes}m';
  }

  static String weekdayShort(int weekday) => _weekdayShortNames[weekday - 1];

  static String weekdayCompact(int weekday) =>
      _weekdayCompactNames[weekday - 1];

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
