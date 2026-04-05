import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';
import 'home_overview_support_widgets.dart';

class NoFamilyHomeState extends StatelessWidget {
  const NoFamilyHomeState({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = context.colors;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, isWide ? 28 : 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: DecoratedBox(
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
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.10),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: scheme.onPrimaryContainer.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.groups_2_rounded,
                            size: 32,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.homeNoFamilyTitle,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.homeNoFamilyMessage,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            HomeOverviewFeaturePill(
                              icon: Icons.calendar_today_rounded,
                              label: l10n.homeFeatureSharedCalendar,
                            ),
                            HomeOverviewFeaturePill(
                              icon: Icons.task_alt_rounded,
                              label: l10n.homeFeatureFamilyTasks,
                            ),
                            HomeOverviewFeaturePill(
                              icon: Icons.shopping_bag_rounded,
                              label: l10n.homeFeatureListsSync,
                            ),
                            HomeOverviewFeaturePill(
                              icon: Icons.savings_rounded,
                              label: l10n.homeFeatureSavingsGoals,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        AppButton(
                          label: l10n.homeAddFamily,
                          onPressed: () {
                            context.go(AppRoutes.family);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
