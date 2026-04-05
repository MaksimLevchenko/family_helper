import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class MoneyGoalCompactMetric extends StatelessWidget {
  const MoneyGoalCompactMetric({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class MoneyGoalStatusChip extends StatelessWidget {
  const MoneyGoalStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum MoneyGoalCompactActionVariant { primary, secondary, danger }

class MoneyGoalCompactActionButton extends StatelessWidget {
  const MoneyGoalCompactActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MoneyGoalCompactActionVariant.primary,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final MoneyGoalCompactActionVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final background = switch (variant) {
      MoneyGoalCompactActionVariant.primary => context.colors.primary,
      MoneyGoalCompactActionVariant.secondary => context.colors.secondary,
      MoneyGoalCompactActionVariant.danger => context.colors.danger,
    };

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: context.colors.background,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
