import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/ui_error_localizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/ui_kit.dart';
import '../../providers/calendar_provider.dart';
import 'calendar_agenda_section.dart';
import 'calendar_layout_constants.dart';
import 'calendar_month_card.dart';

class CalendarScreenContent extends StatelessWidget {
  const CalendarScreenContent({
    super.key,
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
            final isWide = constraints.maxWidth >= calendarWideLayoutBreakpoint;
            final maxWidth = constraints.maxWidth >= calendarMaxWidthBreakpoint
                ? calendarMaxContentWidth
                : double.infinity;

            final monthCard = CalendarMonthCard(
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

            final agendaSection = CalendarAgendaSection(
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
          ..._withVerticalGaps(statusWidgets, gap: 12),
          if (statusWidgets.isNotEmpty) const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  key: const Key('calendar-month-pane'),
                  width: calendarMonthPaneWidth,
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
                  children: _withVerticalGaps(statusWidgets, gap: 12),
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

List<Widget> _withVerticalGaps(List<Widget> widgets, {required double gap}) {
  final spaced = <Widget>[];
  for (var index = 0; index < widgets.length; index++) {
    if (index > 0) {
      spaced.add(SizedBox(height: gap));
    }
    spaced.add(widgets[index]);
  }
  return spaced;
}
