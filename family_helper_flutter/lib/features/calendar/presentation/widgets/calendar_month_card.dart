import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import 'calendar_badges.dart';
import 'calendar_day_cell.dart';
import 'calendar_formatters.dart';

class CalendarMonthCard extends StatelessWidget {
  const CalendarMonthCard({
    super.key,
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
                (left, right) =>
                    left.occurrenceStart.compareTo(right.occurrenceStart),
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
                        CalendarFormatters.fullDate(context, selectedDay),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRefreshing)
                  CalendarBusyPill(label: l10n.calendarUpdatingStatus),
              ],
            ),
            const SizedBox(height: 16),
            _SelectedDaySummaryCard(
              firstUpcoming: firstUpcoming,
              itemCount: selectedAgendaItems.length,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    CalendarFormatters.monthLabel(context, visibleMonth),
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
                        CalendarFormatters.weekdayCompact(
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
    return CalendarDayCell(
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
    required this.firstUpcoming,
    required this.itemCount,
  });

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
                          CalendarFormatters.timeRange(
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
