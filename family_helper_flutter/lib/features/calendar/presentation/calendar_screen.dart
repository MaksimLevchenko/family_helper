import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
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
      appBar: serverStatusAppBar(context, title: Text(context.l10n.homeCalendar)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isOffline ? null : () => _openCreateEvent(context),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: Text(context.l10n.calendarAddEvent),
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
            ..showSnackBar(
              SnackBar(content: Text(localizeUiError(context, state.error))),
            );
        },
        builder: (context, state) {
          if (state.isInitialLoading && state.instances.isEmpty) {
            return LoadingState(label: context.l10n.calendarLoading);
          }

          if (state.error != null &&
              !state.errorFromMutation &&
              state.instances.isEmpty) {
            return ErrorState(
              message: localizeUiError(context, state.error),
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
                      AppBanner(
                        text: localizeUiError(context, state.error),
                        isError: true,
                      ),
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
        title: context.l10n.calendarCreateEventTitle,
        submitLabel: context.l10n.calendarSaveEvent,
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
        title: context.l10n.calendarEditOccurrenceTitle,
        submitLabel: context.l10n.commonSaveChanges,
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
        ? context.l10n.calendarEditFollowingTitle
        : context.l10n.calendarEditWholeSeriesTitle;
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: title,
        submitLabel: context.l10n.commonSaveChanges,
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
          title: context.l10n.calendarDeleteOccurrenceTitle,
          message: context.l10n.calendarDeleteOccurrenceMessage,
          confirmLabel: context.l10n.commonDelete,
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
        ? context.l10n.calendarDeleteSeriesFutureMessage
        : context.l10n.calendarDeleteSeriesAllMessage;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: context.l10n.calendarDeleteEventTitle,
          message: message,
          confirmLabel: context.l10n.commonDelete,
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
      SnackBar(
        content: Text(context.l10n.calendarOfflineMessage),
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
    final l10n = context.l10n;
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
                        l10n.calendarYourScheduleTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _CalendarFormatters.fullDate(context, selectedDay),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRefreshing)
                  _BusyPill(label: l10n.calendarUpdatingStatus),
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
                    _CalendarFormatters.monthLabel(context, visibleMonth),
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
                availableCalendarFormats: {
                  CalendarFormat.month: l10n.calendarFormatMonth,
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
                        _CalendarFormatters.weekdayCompact(
                          context,
                          day.weekday,
                        ),
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
                  hasItems
                      ? context.l10n.calendarPlansForDay(itemCount)
                      : context.l10n.calendarOpenDayTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasItems
                      ? context.l10n.calendarNextEventSummary(
                          _CalendarFormatters.timeRange(
                            context,
                            firstUpcoming!.occurrenceStart,
                            firstUpcoming!.occurrenceEnd,
                          ),
                          firstUpcoming!.title,
                        )
                      : context.l10n.calendarOpenDayEmptyMessage,
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
    final countLabel = context.l10n.calendarEventsCount(items.length);

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
                        context.l10n.calendarAgendaTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _CalendarFormatters.fullDate(context, selectedDay),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRefreshing) ...[
                  const SizedBox(width: 12),
                  _BusyPill(label: context.l10n.calendarRefreshingStatus),
                ],
                if (isMutating && !isRefreshing) ...[
                  const SizedBox(width: 12),
                  _BusyPill(label: context.l10n.calendarSavingStatus),
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
              context.l10n.calendarEmptyDayTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.calendarEmptyDayMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 180,
              child: AppButton(
                label: context.l10n.calendarAddEvent,
                onPressed: onCreateEvent,
              ),
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
                            context,
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
                              _InfoChip(
                                label: context.l10n.calendarRepeatsChip,
                                icon: Icons.repeat_rounded,
                              ),
                            if (instance.isException)
                              _InfoChip(
                                label: context.l10n.calendarEditedChip,
                                icon: Icons.edit_calendar_rounded,
                              ),
                            if (instance.reminderOffsetMinutes != null)
                              _InfoChip(
                                label: _reminderLabel(
                                  context,
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

  String _reminderLabel(BuildContext context, int offsetMinutes) {
    return switch (offsetMinutes) {
      0 => context.l10n.calendarReminderAtTime,
      10 => context.l10n.calendarReminderTenMinutesBefore,
      60 => context.l10n.calendarReminderOneHourBefore,
      1440 => context.l10n.calendarReminderOneDayBefore,
      _ => context.l10n.calendarReminderGeneric,
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
            _CalendarFormatters.timeOfDay(context, start),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _CalendarFormatters.timeOfDay(context, end),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _CalendarFormatters.durationLabel(context, start, end),
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
              context,
              instance.occurrenceStart,
              instance.occurrenceEnd,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          _SheetSection(
            title: context.l10n.calendarActionEditSection,
            children: instance.isRecurring
                ? [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      title: context.l10n.calendarActionEditOccurrence,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editOne),
                    ),
                    _ActionTile(
                      icon: Icons.update_outlined,
                      title: context.l10n.calendarActionEditFollowing,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editFuture),
                    ),
                    _ActionTile(
                      icon: Icons.auto_mode_outlined,
                      title: context.l10n.calendarActionEditWholeSeries,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editAll),
                    ),
                  ]
                : [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      title: context.l10n.calendarActionEditEvent,
                      onTap: () =>
                          Navigator.of(context).pop(_CalendarAction.editAll),
                    ),
                  ],
          ),
          const SizedBox(height: 14),
          _SheetSection(
            title: context.l10n.calendarActionDeleteSection,
            children: instance.isRecurring
                ? [
                    _ActionTile(
                      icon: Icons.delete_outline,
                      title: context.l10n.calendarActionDeleteOccurrence,
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteOne),
                    ),
                    _ActionTile(
                      icon: Icons.event_busy_outlined,
                      title: context.l10n.calendarActionDeleteFollowing,
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteFuture),
                    ),
                    _ActionTile(
                      icon: Icons.delete_forever_outlined,
                      title: context.l10n.calendarActionDeleteWholeSeries,
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteAll),
                    ),
                  ]
                : [
                    _ActionTile(
                      icon: Icons.delete_outline,
                      title: context.l10n.calendarActionDeleteEvent,
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
                          ? context.l10n.calendarEditorRecurringSubtitle
                          : context.l10n.calendarEditorSingleSubtitle,
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
                  title: context.l10n.calendarEditorBasicsTitle,
                  subtitle: context.l10n.calendarEditorBasicsSubtitle,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: context.l10n.calendarEditorTitleLabel,
                      ),
                      if (widget.allowRecurrence) ...[
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _descriptionController,
                          label: context.l10n.calendarEditorNotesLabel,
                          hint: context.l10n.calendarEditorOptionalHint,
                          maxLines: 3,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditorSection(
                  title: context.l10n.calendarEditorScheduleTitle,
                  subtitle: context.l10n.calendarEditorScheduleSubtitle,
                  child: Column(
                    children: [
                      _DateTimeTile(
                        label: context.l10n.calendarEditorStartsLabel,
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
                        label: context.l10n.calendarEditorEndsLabel,
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
                  title: context.l10n.calendarEditorReminderTitle,
                  subtitle: context.l10n.calendarEditorReminderSubtitle,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ReminderPreset.values
                        .map(
                          (preset) => _ChoicePill(
                            label: preset.label(context.l10n),
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
                    title: context.l10n.calendarEditorRepeatTitle,
                    subtitle: context.l10n.calendarEditorRepeatSubtitle,
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
                              context.l10n.calendarEditorDaysOfWeekLabel,
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
                                  context,
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
                            label: context.l10n.calendarEditorRepeatEveryDaysLabel,
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
                        child: Text(context.l10n.commonCancel),
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
        _validationMessage = context.l10n.calendarEditorTitleValidation;
      });
      return;
    }
    if (!_endsAt.isAfter(_startsAt)) {
      setState(() {
        _validationMessage = context.l10n.calendarEditorEndAfterStartValidation;
      });
      return;
    }

    var recurrence = _recurrence;
    if (recurrence.mode == CalendarRecurrenceMode.everyNDays) {
      final interval = int.tryParse(_intervalController.text);
      if (interval == null || interval < 1) {
        setState(() {
          _validationMessage = context.l10n.calendarEditorIntervalValidation;
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
                      _CalendarFormatters.dateTimeLabel(context, value),
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
                      _modeTitle(context, mode),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _modeSubtitle(context, mode),
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

  String _modeTitle(BuildContext context, CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none => context.l10n.calendarRecurrenceNoneTitle,
      CalendarRecurrenceMode.yearly =>
        context.l10n.calendarRecurrenceYearlyTitle,
      CalendarRecurrenceMode.monthly =>
        context.l10n.calendarRecurrenceMonthlyTitle,
      CalendarRecurrenceMode.weekly =>
        context.l10n.calendarRecurrenceWeeklyTitle,
      CalendarRecurrenceMode.everyNDays =>
        context.l10n.calendarRecurrenceEveryNDaysTitle,
    };
  }

  String _modeSubtitle(BuildContext context, CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none =>
        context.l10n.calendarRecurrenceNoneSubtitle,
      CalendarRecurrenceMode.yearly =>
        context.l10n.calendarRecurrenceYearlySubtitle,
      CalendarRecurrenceMode.monthly =>
        context.l10n.calendarRecurrenceMonthlySubtitle,
      CalendarRecurrenceMode.weekly =>
        context.l10n.calendarRecurrenceWeeklySubtitle,
      CalendarRecurrenceMode.everyNDays =>
        context.l10n.calendarRecurrenceEveryNDaysSubtitle,
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
  static String fullDate(BuildContext context, DateTime date) {
    final local = date.toLocal();
    return DateFormat.yMMMMd(_locale(context)).format(local);
  }

  static String monthLabel(BuildContext context, DateTime date) {
    final local = date.toLocal();
    return DateFormat.yMMMM(_locale(context)).format(local);
  }

  static String timeOfDay(BuildContext context, DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateFormat.Hm(_locale(context)).format(local);
  }

  static String timeRange(BuildContext context, DateTime start, DateTime end) {
    return '${timeOfDay(context, start)} - ${timeOfDay(context, end)}';
  }

  static String dateTimeLabel(BuildContext context, DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateFormat.yMMMMd(
      _locale(context),
    ).add_Hm().format(local);
  }

  static String durationLabel(
    BuildContext context,
    DateTime start,
    DateTime end,
  ) {
    final difference = end.difference(start);
    if (difference.inHours >= 1) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      return minutes == 0
          ? context.l10n.calendarDurationHours(hours)
          : context.l10n.calendarDurationHoursMinutes(hours, minutes);
    }
    return context.l10n.calendarDurationMinutes(difference.inMinutes);
  }

  static String weekdayShort(BuildContext context, int weekday) {
    return DateFormat.E(_locale(context)).format(_weekdayDate(weekday));
  }

  static String weekdayCompact(BuildContext context, int weekday) {
    return DateFormat.EEEEE(_locale(context)).format(_weekdayDate(weekday));
  }

  static String _locale(BuildContext context) =>
      Localizations.localeOf(context).toLanguageTag();

  static DateTime _weekdayDate(int weekday) =>
      DateTime.utc(2024, 1, weekday.clamp(1, 7));
}
