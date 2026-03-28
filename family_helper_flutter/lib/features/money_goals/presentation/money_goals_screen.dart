import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/server_availability_cubit.dart';
import '../../../core/routing/app_routes.dart';
import '../../../ui_kit/ui_kit.dart';
import '../providers/money_goals_provider.dart';
import 'widgets/money_goal_detail_card.dart';
import 'widgets/money_goal_forms.dart';
import 'widgets/money_goal_formatters.dart';
import 'widgets/money_goal_list_item.dart';
import 'widgets/money_goals_summary_card.dart';

part 'money_goals_screen_overlays.dart';
part 'money_goals_screen_sections.dart';

class MoneyGoalsScreen extends StatefulWidget {
  const MoneyGoalsScreen({super.key});

  @override
  State<MoneyGoalsScreen> createState() => _MoneyGoalsScreenState();
}

class _MoneyGoalsScreenState extends State<MoneyGoalsScreen> {
  static const _wideLayoutBreakpoint = 720.0;

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Money Goals')),
      body: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
        builder: (context, state) {
          if (state.hasSelectedFamily &&
              state.isInitialLoading &&
              state.goals.isEmpty) {
            return const SafeArea(
              child: LoadingState(label: 'Loading goals...'),
            );
          }

          if (state.hasSelectedFamily &&
              state.error != null &&
              state.goals.isEmpty) {
            return SafeArea(
              child: ErrorState(
                message: state.error!,
                onRetry: () => context.read<MoneyGoalsCubit>().reload(),
              ),
            );
          }

          if (!state.hasSelectedFamily) {
            return SafeArea(
              child: _NoFamilySelectedView(
                onOpenFamily: () {
                  context.go(AppRoutes.family);
                },
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
                  return isWide
                      ? _buildWideLayout(context, state, isOffline: isOffline)
                      : _buildNarrowLayout(
                          context,
                          state,
                          isOffline: isOffline,
                        );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNarrowLayout(
    BuildContext context,
    MoneyGoalsState state, {
    required bool isOffline,
  }) {
    return ListView(
      key: const Key('money-goals-narrow-layout'),
      children: [
        CachedDataStatus(
          isUsingCachedData: state.isUsingCachedData,
          lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
        ),
        if (state.error != null) ...[
          AppBanner(text: state.error!, isError: true),
          const SizedBox(height: 10),
        ],
        MoneyGoalsSummaryCard(goals: state.goals),
        const SizedBox(height: 8),
        _buildDetailSection(
          context,
          state,
          isWide: false,
          isOffline: isOffline,
        ),
        const SizedBox(height: 16),
        _buildMoneyGoalsSections(context, state),
      ],
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    MoneyGoalsState state, {
    required bool isOffline,
  }) {
    return Column(
      key: const Key('money-goals-wide-layout'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedDataStatus(
          isUsingCachedData: state.isUsingCachedData,
          lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
        ),
        if (state.error != null) ...[
          AppBanner(text: state.error!, isError: true),
          const SizedBox(height: 10),
        ],
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                child: _GoalsSidebar(
                  state: state,
                  onSelectGoal: (goalId) {
                    context.read<MoneyGoalsCubit>().setCurrentGoal(goalId);
                  },
                  onCreateGoal: () {
                    if (isOffline) {
                      _showOfflineMessage(context);
                      return;
                    }
                    _showCreateGoalOverlay(
                      context,
                      isWide: true,
                      isOffline: isOffline,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoneyGoalsSummaryCard(goals: state.goals),
                      const SizedBox(height: 12),
                      _buildDetailSection(
                        context,
                        state,
                        isWide: true,
                        isOffline: isOffline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    MoneyGoalsState state, {
    required bool isWide,
    required bool isOffline,
  }) {
    final selectedGoal = state.selectedGoal;

    if (selectedGoal != null) {
      return MoneyGoalDetailCard(
        goal: selectedGoal,
        history: state.history,
        isHistoryLoading: state.isHistoryLoading,
        isUpdatingGoal: state.isUpdatingGoal,
        isAddingContribution: state.isAddingContribution,
        isWithdrawingFunds: state.isWithdrawingFunds,
        isCreatingGoal: state.isCreatingGoal,
        isArchivingGoal: state.isArchivingGoal,
        isDeletingGoal: state.isDeletingGoal,
        onAddContribution: isArchivedGoal(selectedGoal)
            ? () {}
            : () => _showContributionOverlay(
                context,
                selectedGoal,
                isWide: isWide,
                isOffline: isOffline,
              ),
        onWithdrawFunds: isArchivedGoal(selectedGoal)
            ? () {}
            : () => _showWithdrawOverlay(
                context,
                selectedGoal,
                isWide: isWide,
                isOffline: isOffline,
              ),
        onArchiveGoal: isArchivedGoal(selectedGoal)
            ? () {}
            : () => _showArchiveGoalOverlay(
                context,
                selectedGoal,
                isWide: isWide,
                isOffline: isOffline,
              ),
        onDeleteGoal: () => _showDeleteGoalOverlay(
          context,
          selectedGoal,
          isWide: isWide,
          isOffline: isOffline,
        ),
        onCreateGoal: () => _showCreateGoalOverlay(
          context,
          isWide: isWide,
          isOffline: isOffline,
        ),
        onUpdateGoal:
            ({
              required String title,
              required int targetAmountCents,
              String? description,
              DateTime? deadlineAt,
              required String currency,
            }) {
              if (isOffline) {
                _showOfflineMessage(context);
                return Future.value(false);
              }
              return context.read<MoneyGoalsCubit>().updateCurrentGoal(
                title: title,
                targetAmountCents: targetAmountCents,
                description: description,
                deadlineAt: deadlineAt,
                currency: currency,
              );
            },
      );
    }

    if (state.goals.isEmpty) {
      return _EmptyDetailCard(
        title: 'No goals yet',
        message: 'Create your first savings goal and start tracking progress.',
        buttonLabel: 'Create first goal',
        isLoading: state.isCreatingGoal,
        onPressed: () => _showCreateGoalOverlay(
          context,
          isWide: isWide,
          isOffline: isOffline,
        ),
      );
    }

    return _EmptyDetailCard(
      title: 'Pick a goal',
      message:
          'Select a goal from the active list or archive to inspect progress and actions.',
      buttonLabel: 'Create another goal',
      isLoading: state.isCreatingGoal,
      onPressed: () => _showCreateGoalOverlay(
        context,
        isWide: isWide,
        isOffline: isOffline,
      ),
    );
  }

}
