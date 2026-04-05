import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import 'home_overview_support_widgets.dart';

class QuickNavigationCard extends StatelessWidget {
  const QuickNavigationCard({super.key, required this.items});

  final List<HomeSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeQuickNavigation,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.homeQuickNavigationSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  tileColor: scheme.surfaceContainerHigh,
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () => context.go(item.route),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
