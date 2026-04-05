import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import 'home_overview_support_widgets.dart';
import 'info_row_card.dart';

class PriorityTasksList extends StatelessWidget {
  const PriorityTasksList({super.key, required this.tasks});

  final List<TaskDto> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return HomeOverviewSectionEmptyState(
        title: context.l10n.homeNoUrgentTasksTitle,
        message: context.l10n.homeNoUrgentTasksMessage,
      );
    }

    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HomeInfoRowCard(
                title: task.title,
                subtitle:
                    '${homeOverviewTaskUrgencyLabel(context, task)} • ${homeOverviewTaskDueLabel(context, task.dueAt)}',
                icon: Icons.assignment_turned_in_rounded,
                onTap: () => context.go(AppRoutes.tasks),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
