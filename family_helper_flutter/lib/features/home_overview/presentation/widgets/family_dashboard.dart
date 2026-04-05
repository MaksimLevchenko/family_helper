import 'package:flutter/material.dart';

import '../../../../ui_kit/cached_data_status.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../notifications/domain/notification_models.dart';
import '../../../family_invites/providers/family_provider.dart';
import '../../../notifications/providers/notifications_provider.dart';
import '../../providers/home_overview_provider.dart';
import 'goal_spotlight_card.dart';
import 'home_overview_hero_card.dart';
import 'home_overview_section_card.dart';
import 'home_overview_summary_grid.dart';
import 'home_overview_support_widgets.dart';
import 'list_spotlight_card.dart';
import 'notification_alert_card.dart';
import 'priority_tasks_list.dart';
import 'quick_navigation_card.dart';
import 'upcoming_events_list.dart';

class FamilyDashboard extends StatelessWidget {
  const FamilyDashboard({
    super.key,
    required this.overview,
    required this.familyState,
    required this.notifications,
    required this.isWide,
    required this.summaryItems,
  });

  final HomeOverviewState overview;
  final FamilyMembersState familyState;
  final NotificationsState notifications;
  final bool isWide;
  final List<HomeSummaryItem> summaryItems;

  @override
  Widget build(BuildContext context) {
    final railWidth = MediaQuery.sizeOf(context).width >= 980 ? 340.0 : 300.0;
    final sections = <Widget>[
      HomeOverviewHeroCard(
        familyState: familyState,
        metrics: summaryItems,
      ),
      const SizedBox(height: 20),
      CachedDataStatus(
        isUsingCachedData: overview.isUsingCachedData,
        lastSuccessfulSyncAt: overview.lastSuccessfulSyncAt,
      ),
      HomeOverviewSummaryGrid(
        items: summaryItems,
        isWide: isWide,
      ),
      const SizedBox(height: 20),
      HomeOverviewSectionCard(
        title: context.l10n.homeComingUp,
        subtitle: context.l10n.homeComingUpSubtitle,
        child: UpcomingEventsList(events: overview.upcomingEvents),
      ),
      const SizedBox(height: 20),
      HomeOverviewSectionCard(
        title: context.l10n.homeNeedsAttention,
        subtitle: context.l10n.homeNeedsAttentionSubtitle,
        child: PriorityTasksList(tasks: overview.priorityTasks),
      ),
    ];

    final sideRail = <Widget>[
      if (!notifications.permissionStatus.isGranted) ...[
        NotificationAlertCard(notifications: notifications),
        const SizedBox(height: 20),
      ],
      QuickNavigationCard(items: summaryItems),
      const SizedBox(height: 20),
      GoalSpotlightCard(goal: overview.featuredGoal),
      const SizedBox(height: 20),
      ListSpotlightCard(
        list: overview.featuredList,
        pendingItems: overview.featuredListPendingItems,
      ),
    ];

    if (!isWide) {
      sections.addAll([
        const SizedBox(height: 20),
        if (!notifications.permissionStatus.isGranted) ...[
          NotificationAlertCard(notifications: notifications),
          const SizedBox(height: 20),
        ],
        GoalSpotlightCard(goal: overview.featuredGoal),
        const SizedBox(height: 20),
        ListSpotlightCard(
          list: overview.featuredList,
          pendingItems: overview.featuredListPendingItems,
        ),
      ]);
    }

    return CustomScrollView(
      key: Key(
        isWide ? 'home-dashboard-wide-layout' : 'home-dashboard-narrow-layout',
      ),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, isWide ? 28 : 24),
          sliver: SliverToBoxAdapter(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sections,
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: railWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sideRail,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sections,
                  ),
          ),
        ),
      ],
    );
  }
}
