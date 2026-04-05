import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';
import 'calendar_badges.dart';
import 'calendar_formatters.dart';

class CalendarAgendaSection extends StatelessWidget {
  const CalendarAgendaSection({
    super.key,
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
      if (isRefreshing)
        CalendarBusyPill(label: context.l10n.calendarRefreshingStatus),
      if (isMutating && !isRefreshing)
        CalendarBusyPill(label: context.l10n.calendarSavingStatus),
      CalendarCountBadge(label: countLabel),
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
                      CalendarFormatters.fullDate(context, selectedDay),
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
                  _TimeBlock(
                    start: instance.occurrenceStart.toLocal(),
                    end: instance.occurrenceEnd.toLocal(),
                  ),
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
                          CalendarFormatters.timeRange(
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
                              CalendarInfoChip(
                                label: context.l10n.calendarRepeatsChip,
                                icon: Icons.repeat_rounded,
                              ),
                            if (instance.isException)
                              CalendarInfoChip(
                                label: context.l10n.calendarEditedChip,
                                icon: Icons.edit_calendar_rounded,
                              ),
                            if (instance.reminderOffsetMinutes != null)
                              CalendarInfoChip(
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
            CalendarFormatters.timeOfDay(context, start),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CalendarFormatters.timeOfDay(context, end),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            CalendarFormatters.durationLabel(context, start, end),
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
