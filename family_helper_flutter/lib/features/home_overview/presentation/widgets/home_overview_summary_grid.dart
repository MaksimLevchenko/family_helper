import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_overview_support_widgets.dart';

class HomeOverviewSummaryGrid extends StatelessWidget {
  const HomeOverviewSummaryGrid({
    super.key,
    required this.items,
    required this.isWide,
  });

  final List<HomeSummaryItem> items;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          >= 960 => 4,
          >= 660 => 3,
          _ => 2,
        };
        final mainAxisExtent = switch (crossAxisCount) {
          4 => 196.0,
          3 => 204.0,
          _ => 220.0,
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return HomeOverviewSummaryCard(item: item);
          },
        );
      },
    );
  }
}

class HomeOverviewSummaryCard extends StatelessWidget {
  const HomeOverviewSummaryCard({super.key, required this.item});

  final HomeSummaryItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      key: Key('home-summary-${item.key}'),
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.go(item.route),
      child: Ink(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
