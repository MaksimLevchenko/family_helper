import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
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
