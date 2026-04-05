import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.task});

  final TaskDto task;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'completed';
    final color = isCompleted ? context.colors.success : context.colors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isCompleted
            ? context.l10n.tasksStatusCompleted
            : context.l10n.tasksStatusOpen,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.accentColor,
    this.isCompact = false,
  });

  final String title;
  final String value;
  final Color? accentColor;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? context.colors.primary;
    return Container(
      constraints: BoxConstraints(minWidth: isCompact ? 96 : 120),
      padding: EdgeInsets.all(isCompact ? 10 : 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: context.colors.textSecondary)),
          SizedBox(height: isCompact ? 4 : 6),
          Text(
            value,
            style:
                (isCompact
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.headlineSmall)
                    ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: context.colors.textSecondary)),
      ],
    );
  }
}

class NoFamilyTasksView extends StatelessWidget {
  const NoFamilyTasksView({super.key, required this.onOpenFamily});

  final VoidCallback onOpenFamily;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyText(
              title: context.l10n.tasksNoFamilyTitle,
              message: context.l10n.tasksNoFamilyMessage,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.tasksOpenFamilySettings,
              onPressed: onOpenFamily,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyText extends StatelessWidget {
  const EmptyText({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.textSecondary),
        ),
      ],
    );
  }
}
