import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../ui_kit/family_member_avatar.dart';
import '../../../family_invites/providers/family_provider.dart';
import 'home_overview_support_widgets.dart';

class HomeOverviewHeroCard extends StatelessWidget {
  const HomeOverviewHeroCard({
    super.key,
    required this.familyState,
    required this.metrics,
  });

  final FamilyMembersState familyState;
  final List<HomeSummaryItem> metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final familyName = familyState.family?.title ?? l10n.homeHeroFamilyFallback;
    final activeMembers = familyState.members
        .where((member) => member.status == 'active')
        .toList();
    final memberCount = activeMembers.length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.surfaceContainerHighest,
            scheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -22,
            right: -18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.onPrimaryContainer.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(80),
              ),
              child: const SizedBox(width: 140, height: 140),
            ),
          ),
          Positioned(
            bottom: -34,
            left: -10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const SizedBox(width: 180, height: 180),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.60),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    memberCount > 0
                        ? '$familyName • ${l10n.settingsMemberCount(memberCount)}'
                        : '$familyName • ${l10n.homeHeroSharedDashboard}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (activeMembers.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activeMembers
                        .take(5)
                        .map(
                          (member) => Tooltip(
                            message: member.displayName,
                            child: FamilyMemberAvatar(
                              displayName: member.displayName,
                              avatarMediaId: member.avatarMediaId,
                              size: 36,
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  l10n.homeHeroTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.homeHeroSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: metrics
                      .map(
                        (item) => FilledButton.tonalIcon(
                          key: Key('home-quick-action-${item.key}'),
                          onPressed: () => context.go(item.route),
                          icon: Icon(item.icon, size: 18),
                          label: Text(item.title),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
