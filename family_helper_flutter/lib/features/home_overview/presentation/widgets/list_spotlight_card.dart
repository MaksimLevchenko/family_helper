import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import 'home_overview_support_widgets.dart';

class ListSpotlightCard extends StatelessWidget {
  const ListSpotlightCard({
    super.key,
    required this.list,
    required this.pendingItems,
  });

  final FamilyListDto? list;
  final int pendingItems;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (list == null) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeListsSpotlight,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              HomeOverviewSectionEmptyState(
                title: l10n.homeNoListsTitle,
                message: l10n.homeNoListsMessage,
              ),
            ],
          ),
        ),
      );
    }

    final listTypeLabel = homeOverviewListTypeLabel(context, list!.listType);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeListsSpotlight,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              list!.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                HomeOverviewMetaBadge(label: listTypeLabel),
                HomeOverviewMetaBadge(
                  label: l10n.homeListItemsOpen(pendingItems),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              pendingItems == 0
                  ? l10n.homeListEverythingDone
                  : l10n.homeListMomentum,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => context.go(AppRoutes.lists),
              child: Text(l10n.homeOpenLists),
            ),
          ],
        ),
      ),
    );
  }
}
