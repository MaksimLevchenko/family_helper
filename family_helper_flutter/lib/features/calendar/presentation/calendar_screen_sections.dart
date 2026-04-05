part of 'calendar_screen.dart';

class _CalendarScreenContent extends StatelessWidget {
  const _CalendarScreenContent({
    required this.state,
    required this.isOffline,
    required this.onCreateEvent,
    required this.onOpenInstanceActions,
  });

  final CalendarState state;
  final bool isOffline;
  final VoidCallback onCreateEvent;
  final ValueChanged<CalendarInstanceDto> onOpenInstanceActions;

  @override
  Widget build(BuildContext context) {
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
            final isWide =
                constraints.maxWidth >= _calendarWideLayoutBreakpoint;
            final maxWidth = constraints.maxWidth >= _calendarMaxWidthBreakpoint
                ? _calendarMaxContentWidth
                : double.infinity;

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
                context.read<CalendarCubit>().setVisibleMonth(focusedDay);
              },
            );

            final agendaSection = _AgendaSection(
              selectedDay: state.selectedDay,
              items: agendaItems,
              isRefreshing: state.isMonthTransitioning,
              isMutating: state.isMutating,
              isPendingItem: state.isPendingInstance,
              onTapItem: onOpenInstanceActions,
              onCreateEvent: onCreateEvent,
            );

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

            final body = isWide
                ? _CalendarWideLayout(
                    statusWidgets: statusWidgets,
                    monthCard: monthCard,
                    agendaSection: agendaSection,
                  )
                : _CalendarNarrowLayout(
                    constraints: constraints,
                    statusWidgets: statusWidgets,
                    monthCard: monthCard,
                    agendaSection: agendaSection,
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
  }
}

class _CalendarWideLayout extends StatelessWidget {
  const _CalendarWideLayout({
    required this.statusWidgets,
    required this.monthCard,
    required this.agendaSection,
  });

  final List<Widget> statusWidgets;
  final Widget monthCard;
  final Widget agendaSection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        key: const Key('calendar-wide-layout'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._withGaps(statusWidgets, gap: 12),
          if (statusWidgets.isNotEmpty) const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  key: const Key('calendar-month-pane'),
                  width: _calendarMonthPaneWidth,
                  child: SingleChildScrollView(child: monthCard),
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
    );
  }
}

class _CalendarNarrowLayout extends StatelessWidget {
  const _CalendarNarrowLayout({
    required this.constraints,
    required this.statusWidgets,
    required this.monthCard,
    required this.agendaSection,
  });

  final BoxConstraints constraints;
  final List<Widget> statusWidgets;
  final Widget monthCard;
  final Widget agendaSection;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('calendar-narrow-layout'),
      padding: const EdgeInsets.only(bottom: 96),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          children: [
            if (statusWidgets.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: _withGaps(statusWidgets, gap: 12),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: monthCard,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: agendaSection,
            ),
          ],
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
                if (isRefreshing) _BusyPill(label: l10n.calendarUpdatingStatus),
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
    final headerBadges = <Widget>[
      if (isRefreshing) _BusyPill(label: context.l10n.calendarRefreshingStatus),
      if (isMutating && !isRefreshing)
        _BusyPill(label: context.l10n.calendarSavingStatus),
      _CountBadge(label: countLabel),
    ];

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useStackedHeader = constraints.maxWidth < 420;

                final titleBlock = Column(
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
                );

                final badges = Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: headerBadges,
                );

                if (useStackedHeader) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleBlock,
                      const SizedBox(height: 12),
                      badges,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: titleBlock),
                    const SizedBox(width: 12),
                    Flexible(child: badges),
                  ],
                );
              },
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
