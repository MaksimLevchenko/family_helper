import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui_kit/ui_kit.dart';
import '../providers/money_goals_provider.dart';

class MoneyGoalsScreen extends StatefulWidget {
  const MoneyGoalsScreen({super.key});

  @override
  State<MoneyGoalsScreen> createState() => _MoneyGoalsScreenState();
}

class _MoneyGoalsScreenState extends State<MoneyGoalsScreen> {
  final _goalTitleController = TextEditingController();
  final _targetController = TextEditingController();
  final _contributionController = TextEditingController();

  @override
  void dispose() {
    _goalTitleController.dispose();
    _targetController.dispose();
    _contributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Money Goals')),
      body: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
        builder: (context, state) {
          if (state.isLoading && state.goals.isEmpty) {
            return const LoadingState();
          }

          if (state.error != null && state.goals.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<MoneyGoalsCubit>().reload(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppTextField(
                controller: _goalTitleController,
                label: 'Goal title',
              ),
              const SizedBox(height: 12),
              MoneyField(
                controller: _targetController,
                label: 'Target amount (cents)',
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create goal',
                onPressed: () async {
                  final title = _goalTitleController.text.trim();
                  final amount = int.tryParse(_targetController.text.trim());
                  if (title.isEmpty || amount == null) {
                    return;
                  }
                  await context.read<MoneyGoalsCubit>().createGoal(
                    title: title,
                    targetAmountCents: amount,
                  );
                },
              ),
              const SizedBox(height: 16),
              MoneyField(
                controller: _contributionController,
                label: 'Contribution amount (cents)',
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Add contribution to selected goal',
                onPressed: () async {
                  final amount = int.tryParse(
                    _contributionController.text.trim(),
                  );
                  if (amount == null) {
                    return;
                  }
                  await context.read<MoneyGoalsCubit>().addContribution(
                    amountCents: amount,
                  );
                },
              ),
              const SizedBox(height: 24),
              if (state.goals.isEmpty)
                const EmptyState(
                  title: 'No goals',
                  message: 'Create a savings goal and track progress.',
                )
              else
                ...state.goals.map(
                  (goal) => AppTile(
                    title: goal.title,
                    subtitle:
                        'Progress: ${goal.currentAmountCents}/${goal.targetAmountCents} ${goal.currency}',
                    onTap: () =>
                        context.read<MoneyGoalsCubit>().setCurrentGoal(goal.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
