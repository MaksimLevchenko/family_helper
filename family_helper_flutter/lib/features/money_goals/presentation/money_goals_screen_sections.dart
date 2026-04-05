part of 'money_goals_screen.dart';

class _GoalsSidebar extends StatelessWidget {
  const _GoalsSidebar({
    required this.state,
    required this.onSelectGoal,
    required this.onCreateGoal,
  });

  final MoneyGoalsState state;
  final ValueChanged<int> onSelectGoal;
  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final activeGoals = state.activeGoals;
    final archivedGoals = state.archivedGoals;

    if (activeGoals.isEmpty && archivedGoals.isEmpty) {
      return _EmptyGoalsList(onCreateGoal: onCreateGoal);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: context.l10n.moneyGoalsSectionTitle,
          subtitle: context.l10n.moneyGoalsSidebarSummary(
            activeGoals.length,
            archivedGoals.length,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              if (activeGoals.isNotEmpty) ...[
                Text(
                  context.l10n.moneyGoalsActiveSection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                _ExpandableGoalList(
                  goals: activeGoals,
                  currentGoalId: state.currentGoalId,
                  onSelectGoal: onSelectGoal,
                ),
              ],
              if (archivedGoals.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  context.l10n.moneyGoalsArchivedSection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                _ExpandableGoalList(
                  goals: archivedGoals,
                  currentGoalId: state.currentGoalId,
                  onSelectGoal: onSelectGoal,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpandableGoalList extends StatefulWidget {
  const _ExpandableGoalList({
    required this.goals,
    required this.currentGoalId,
    required this.onSelectGoal,
  });

  final List<MoneyGoalDto> goals;
  final int? currentGoalId;
  final ValueChanged<int> onSelectGoal;

  @override
  State<_ExpandableGoalList> createState() => _ExpandableGoalListState();
}

class _ExpandableGoalListState extends State<_ExpandableGoalList> {
  static const _collapsedGoalCount = 5;
  bool _isExpanded = false;

  @override
  void didUpdateWidget(covariant _ExpandableGoalList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goals != widget.goals &&
        widget.goals.length <= _collapsedGoalCount) {
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleGoals = _isExpanded
        ? widget.goals
        : _collapsedGoals(
            widget.goals,
            currentGoalId: widget.currentGoalId,
          );

    return Column(
      children: [
        for (var index = 0; index < visibleGoals.length; index++) ...[
          MoneyGoalListItem(
            goal: visibleGoals[index],
            isSelected: visibleGoals[index].id == widget.currentGoalId,
            onTap: () => widget.onSelectGoal(visibleGoals[index].id),
          ),
          if (index != visibleGoals.length - 1) const SizedBox(height: 8),
        ],
        if (widget.goals.length > _collapsedGoalCount) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: Key(
                _isExpanded
                    ? 'goal-list-show-less-button'
                    : 'goal-list-show-more-button',
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded
                    ? context.l10n.commonShowLess
                    : context.l10n.commonShowMore,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<MoneyGoalDto> _collapsedGoals(
    List<MoneyGoalDto> goals, {
    required int? currentGoalId,
  }) {
    if (goals.length <= _collapsedGoalCount) {
      return goals;
    }

    final firstGoals = goals.take(_collapsedGoalCount).toList();
    if (currentGoalId == null ||
        firstGoals.any((goal) => goal.id == currentGoalId)) {
      return firstGoals;
    }

    MoneyGoalDto? selectedGoal;
    for (final goal in goals) {
      if (goal.id == currentGoalId) {
        selectedGoal = goal;
        break;
      }
    }
    if (selectedGoal == null) {
      return firstGoals;
    }

    return [
      ...firstGoals.take(_collapsedGoalCount - 1),
      selectedGoal,
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _InlineEmptySection extends StatelessWidget {
  const _InlineEmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(message),
      ),
    );
  }
}

class _NoFamilySelectedView extends StatelessWidget {
  const _NoFamilySelectedView({required this.onOpenFamily});

  final VoidCallback onOpenFamily;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmptyMessage(
              title: context.l10n.moneyGoalsNoFamilyTitle,
              message: context.l10n.moneyGoalsNoFamilyMessage,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.moneyGoalsOpenFamilySettings,
              onPressed: onOpenFamily,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDetailCard extends StatelessWidget {
  const _EmptyDetailCard({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.isLoading,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('money-goals-empty-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EmptyMessage(title: title, message: message),
            const SizedBox(height: 12),
            AppButton(
              label: buttonLabel,
              isLoading: isLoading,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGoalsList extends StatelessWidget {
  const _EmptyGoalsList({required this.onCreateGoal});

  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmptyMessage(
              title: context.l10n.moneyGoalsEmptyTitle,
              message: context.l10n.moneyGoalsEmptyMessage,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.moneyGoalsCreateFirstGoal,
              onPressed: onCreateGoal,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({
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
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
