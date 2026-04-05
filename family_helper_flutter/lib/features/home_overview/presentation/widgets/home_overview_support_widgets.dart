import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

class HomeSummaryItem {
  const HomeSummaryItem({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.route,
    required this.key,
  });

  final String title;
  final String value;
  final String description;
  final IconData icon;
  final String route;
  final String key;
}

class HomeOverviewSectionEmptyState extends StatelessWidget {
  const HomeOverviewSectionEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeOverviewMetaBadge extends StatelessWidget {
  const HomeOverviewMetaBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class HomeOverviewFeaturePill extends StatelessWidget {
  const HomeOverviewFeaturePill({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String homeOverviewEventTimeLabel(CalendarInstanceDto event) {
  final startsAt = event.occurrenceStart.toLocal();
  final endsAt = event.occurrenceEnd.toLocal();
  return '${_formatMonthDay(startsAt)} • ${_twoDigits(startsAt.hour)}:${_twoDigits(startsAt.minute)}-${_twoDigits(endsAt.hour)}:${_twoDigits(endsAt.minute)}';
}

String homeOverviewTaskUrgencyLabel(BuildContext context, TaskDto task) {
  final l10n = context.l10n;
  if (task.dueAt == null) {
    return l10n.homeTaskUrgencyNoDate;
  }
  if (homeOverviewIsTaskOverdue(task)) {
    return l10n.homeTaskUrgencyOverdue;
  }
  if (homeOverviewIsTaskDueToday(task)) {
    return l10n.homeTaskUrgencyToday;
  }
  return l10n.homeTaskUrgencyUpcoming;
}

String homeOverviewTaskDueLabel(BuildContext context, DateTime? dueAt) {
  if (dueAt == null) {
    return context.l10n.homeTaskDueHint;
  }

  final local = dueAt.toLocal();
  return '${_formatMonthDay(local)} • ${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
}

bool homeOverviewIsTaskOverdue(TaskDto task) {
  final dueAt = task.dueAt;
  if (dueAt == null) {
    return false;
  }

  final now = DateTime.now().toUtc();
  return dueAt.isBefore(DateTime.utc(now.year, now.month, now.day));
}

bool homeOverviewIsTaskDueToday(TaskDto task) {
  final dueAt = task.dueAt;
  if (dueAt == null) {
    return false;
  }

  final localDue = dueAt.toLocal();
  final now = DateTime.now();
  return localDue.year == now.year &&
      localDue.month == now.month &&
      localDue.day == now.day;
}

String homeOverviewListTypeLabel(BuildContext context, String value) {
  return switch (value) {
    'shopping' => context.l10n.listTypeShopping,
    'todo' => context.l10n.listTypeTodo,
    _ => value,
  };
}

String _formatMonthDay(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$month/$day';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
