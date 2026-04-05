import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../money_goals/presentation/widgets/money_goal_formatters.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../notifications/domain/notification_models.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
import '../providers/home_overview_provider.dart';

const _wideLayoutBreakpoint = 720.0;
const _maxWidthBreakpoint = 1100.0;
const _maxContentWidth = 1280.0;

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final familyId = context.watch<FamilySelectionCubit>().state;
    final familyState =
        context.watch<FamilyMembersCubit?>()?.state ??
        FamilyMembersState.initial(familyId: familyId);
    final hasFamily = familyId != null;
    final tasks = context.watch<TasksCubit>().state;
    final calendar = context.watch<CalendarCubit>().state;
    final lists = context.watch<ListsCubit>().state;
    final goals = context.watch<MoneyGoalsCubit>().state;
    final notifications = context.watch<NotificationsCubit>().state;

    final overview = computeOverview(
      tasks: tasks,
      calendar: calendar,
      lists: lists,
      goals: goals,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: serverStatusAppBar(context, title: Text(context.l10n.homeTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
            final maxWidth = constraints.maxWidth >= _maxWidthBreakpoint
                ? _maxContentWidth
                : double.infinity;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: hasFamily
                    ? _FamilyDashboard(
                        overview: overview,
                        familyState: familyState,
                        notifications: notifications,
                        isWide: isWide,
                      )
                    : _NoFamilyHomeState(isWide: isWide),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FamilyDashboard extends StatelessWidget {
  const _FamilyDashboard({
    required this.overview,
    required this.familyState,
    required this.notifications,
    required this.isWide,
  });

  final HomeOverviewState overview;
  final FamilyMembersState familyState;
  final NotificationsState notifications;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final railWidth = MediaQuery.sizeOf(context).width >= 980 ? 340.0 : 300.0;
    final sections = <Widget>[
      _HeroCard(
        familyState: familyState,
        metrics: _summaryItems(context),
      ),
      const SizedBox(height: 20),
      CachedDataStatus(
        isUsingCachedData: overview.isUsingCachedData,
        lastSuccessfulSyncAt: overview.lastSuccessfulSyncAt,
      ),
      _SummaryGrid(
        items: _summaryItems(context),
        isWide: isWide,
      ),
      const SizedBox(height: 20),
      _SectionCard(
        title: context.l10n.homeComingUp,
        subtitle: context.l10n.homeComingUpSubtitle,
        child: _UpcomingEventsList(events: overview.upcomingEvents),
      ),
      const SizedBox(height: 20),
      _SectionCard(
        title: context.l10n.homeNeedsAttention,
        subtitle: context.l10n.homeNeedsAttentionSubtitle,
        child: _PriorityTasksList(tasks: overview.priorityTasks),
      ),
    ];

    final sideRail = <Widget>[
      if (!notifications.permissionStatus.isGranted) ...[
        _NotificationAlertCard(notifications: notifications),
        const SizedBox(height: 20),
      ],
      _QuickNavigationCard(items: _summaryItems(context)),
      const SizedBox(height: 20),
      _GoalSpotlightCard(goal: overview.featuredGoal),
      const SizedBox(height: 20),
      _ListSpotlightCard(
        list: overview.featuredList,
        pendingItems: overview.featuredListPendingItems,
      ),
    ];

    if (!isWide) {
      sections.addAll([
        const SizedBox(height: 20),
        if (!notifications.permissionStatus.isGranted) ...[
          _NotificationAlertCard(notifications: notifications),
          const SizedBox(height: 20),
        ],
        _GoalSpotlightCard(goal: overview.featuredGoal),
        const SizedBox(height: 20),
        _ListSpotlightCard(
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

  List<_SummaryItem> _summaryItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _SummaryItem(
        title: l10n.homeTasks,
        value: '${overview.openTasks}',
        description: l10n.homeTasksDescription,
        icon: Icons.task_alt_rounded,
        route: AppRoutes.tasks,
        key: 'tasks',
      ),
      _SummaryItem(
        title: l10n.homeCalendar,
        value: '${overview.calendarItems}',
        description: l10n.homeCalendarDescription,
        icon: Icons.calendar_month_rounded,
        route: AppRoutes.calendar,
        key: 'calendar',
      ),
      _SummaryItem(
        title: l10n.homeLists,
        value: '${overview.listItems}',
        description: l10n.homeListsDescription,
        icon: Icons.list_alt_rounded,
        route: AppRoutes.lists,
        key: 'lists',
      ),
      _SummaryItem(
        title: l10n.homeGoals,
        value: '${overview.activeGoals}',
        description: l10n.homeGoalsDescription,
        icon: Icons.savings_rounded,
        route: AppRoutes.goals,
        key: 'goals',
      ),
    ];
  }
}

class _NoFamilyHomeState extends StatelessWidget {
  const _NoFamilyHomeState({required this.isWide});

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
                            _FeaturePill(
                              icon: Icons.calendar_today_rounded,
                              label: l10n.homeFeatureSharedCalendar,
                            ),
                            _FeaturePill(
                              icon: Icons.task_alt_rounded,
                              label: l10n.homeFeatureFamilyTasks,
                            ),
                            _FeaturePill(
                              icon: Icons.shopping_bag_rounded,
                              label: l10n.homeFeatureListsSync,
                            ),
                            _FeaturePill(
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.familyState,
    required this.metrics,
  });

  final FamilyMembersState familyState;
  final List<_SummaryItem> metrics;

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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.items,
    required this.isWide,
  });

  final List<_SummaryItem> items;
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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: isWide ? 208 : 188,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _SummaryCard(item: item);
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.item});

  final _SummaryItem item;

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
              const Spacer(),
              Text(
                item.value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _UpcomingEventsList extends StatelessWidget {
  const _UpcomingEventsList({required this.events});

  final List<CalendarInstanceDto> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _SectionEmptyState(
        title: context.l10n.homeNoUpcomingEventsTitle,
        message: context.l10n.homeNoUpcomingEventsMessage,
      );
    }

    return Column(
      children: events
          .map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InfoRowCard(
                title: event.title,
                subtitle: _eventTimeLabel(event),
                icon: Icons.event_available_rounded,
                onTap: () => context.go(AppRoutes.calendar),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _PriorityTasksList extends StatelessWidget {
  const _PriorityTasksList({required this.tasks});

  final List<TaskDto> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _SectionEmptyState(
        title: context.l10n.homeNoUrgentTasksTitle,
        message: context.l10n.homeNoUrgentTasksMessage,
      );
    }

    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InfoRowCard(
                title: task.title,
                subtitle:
                    '${_taskUrgencyLabel(context, task)} • ${_taskDueLabel(context, task.dueAt)}',
                icon: Icons.assignment_turned_in_rounded,
                onTap: () => context.go(AppRoutes.tasks),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _NotificationAlertCard extends StatelessWidget {
  const _NotificationAlertCard({required this.notifications});

  final NotificationsState notifications;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: scheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    notifications.permissionStatus ==
                            NotificationPermissionStatus.notDetermined
                        ? context.l10n.homeNotificationEnableTitle
                        : context.l10n.homeNotificationBlockedTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notifications.permissionStatus.description(context.l10n),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onTertiaryContainer.withValues(alpha: 0.86),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: notifications.permissionStatus.actionLabel(context.l10n),
              isLoading: notifications.isLoading,
              onPressed: () async {
                final cubit = context.read<NotificationsCubit>();
                if (notifications.permissionStatus ==
                    NotificationPermissionStatus.notDetermined) {
                  await cubit.requestSystemPermission();
                } else {
                  await cubit.openSystemNotificationSettings();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickNavigationCard extends StatelessWidget {
  const _QuickNavigationCard({required this.items});

  final List<_SummaryItem> items;

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

class _GoalSpotlightCard extends StatelessWidget {
  const _GoalSpotlightCard({required this.goal});

  final MoneyGoalDto? goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (goal == null) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeSavingsSpotlight,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              _SectionEmptyState(
                title: l10n.homeNoGoalsTitle,
                message: l10n.homeNoGoalsMessage,
              ),
            ],
          ),
        ),
      );
    }

    final progress = goalProgressValue(goal!);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeSavingsSpotlight,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              goal!.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatGoalProgressLabel(context, goal!),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: progress,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaBadge(label: formatProgressPercent(progress)),
                _MetaBadge(
                  label: l10n.homeGoalLeft(formatRemainingAmount(goal!)),
                ),
              ],
            ),
            if (goal!.deadlineAt != null) ...[
              const SizedBox(height: 12),
              Text(
                l10n.homeDeadline(formatShortDate(context, goal!.deadlineAt!)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => context.go(AppRoutes.goals),
              child: Text(l10n.homeOpenGoals),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListSpotlightCard extends StatelessWidget {
  const _ListSpotlightCard({
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
              _SectionEmptyState(
                title: l10n.homeNoListsTitle,
                message: l10n.homeNoListsMessage,
              ),
            ],
          ),
        ),
      );
    }

    final listTypeLabel = _listTypeLabel(context, list!.listType);

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
                _MetaBadge(label: listTypeLabel),
                _MetaBadge(label: l10n.homeListItemsOpen(pendingItems)),
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

class _InfoRowCard extends StatelessWidget {
  const _InfoRowCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionEmptyState extends StatelessWidget {
  const _SectionEmptyState({
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

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.label});

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

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({
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

class _SummaryItem {
  const _SummaryItem({
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

String _eventTimeLabel(CalendarInstanceDto event) {
  final startsAt = event.occurrenceStart.toLocal();
  final endsAt = event.occurrenceEnd.toLocal();
  return '${_formatMonthDay(startsAt)} • ${_twoDigits(startsAt.hour)}:${_twoDigits(startsAt.minute)}-${_twoDigits(endsAt.hour)}:${_twoDigits(endsAt.minute)}';
}

String _taskUrgencyLabel(BuildContext context, TaskDto task) {
  final l10n = context.l10n;
  if (task.dueAt == null) {
    return l10n.homeTaskUrgencyNoDate;
  }
  if (_isTaskOverdue(task)) {
    return l10n.homeTaskUrgencyOverdue;
  }
  if (_isTaskDueToday(task)) {
    return l10n.homeTaskUrgencyToday;
  }
  return l10n.homeTaskUrgencyUpcoming;
}

String _taskDueLabel(BuildContext context, DateTime? dueAt) {
  if (dueAt == null) {
    return context.l10n.homeTaskDueHint;
  }

  final local = dueAt.toLocal();
  return '${_formatMonthDay(local)} • ${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
}

bool _isTaskOverdue(TaskDto task) {
  final dueAt = task.dueAt;
  if (dueAt == null) {
    return false;
  }

  final now = DateTime.now().toUtc();
  return dueAt.isBefore(DateTime.utc(now.year, now.month, now.day));
}

bool _isTaskDueToday(TaskDto task) {
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

String _formatMonthDay(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$month/$day';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _listTypeLabel(BuildContext context, String value) {
  return switch (value) {
    'shopping' => context.l10n.listTypeShopping,
    'todo' => context.l10n.listTypeTodo,
    _ => value,
  };
}
