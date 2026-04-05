import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import 'task_filter.dart';
import 'task_list_item.dart';
import 'task_workspace_common_widgets.dart';
import 'task_workspace_utils.dart';

class TasksSidebar extends StatelessWidget {
  const TasksSidebar({
    super.key,
    required this.visibleTasks,
    required this.currentFilter,
    required this.selectedTaskId,
    required this.members,
    required this.currentProfileId,
    required this.isCompletingTask,
    required this.isOffline,
    this.isEmbedded = false,
    required this.onSelectTask,
    required this.onCompleteTask,
  });

  final List<TaskDto> visibleTasks;
  final TaskFilter currentFilter;
  final int? selectedTaskId;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isCompletingTask;
  final bool isOffline;
  final bool isEmbedded;
  final ValueChanged<int> onSelectTask;
  final Future<void> Function(TaskDto task) onCompleteTask;

  @override
  Widget build(BuildContext context) {
    if (visibleTasks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EmptyText(
            title: currentFilter == TaskFilter.completed
                ? context.l10n.tasksEmptyArchiveTitle
                : context.l10n.tasksEmptyFilteredTitle,
            message: currentFilter == TaskFilter.completed
                ? context.l10n.tasksEmptyArchiveMessage
                : context.l10n.tasksEmptyFilteredMessage,
          ),
        ),
      );
    }

    final sections = currentFilter == TaskFilter.completed
        ? [
            TaskSectionData(
              title: context.l10n.tasksFilterCompletedArchive,
              tasks: visibleTasks,
            ),
          ]
        : groupOpenTasks(context, visibleTasks);

    return ListView(
      key: const Key('tasks-sidebar'),
      shrinkWrap: isEmbedded,
      physics: isEmbedded
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      children: [
        for (
          var sectionIndex = 0;
          sectionIndex < sections.length;
          sectionIndex++
        )
          if (sections[sectionIndex].tasks.isNotEmpty) ...[
            SectionHeader(
              title: sections[sectionIndex].title,
              subtitle: context.l10n.tasksTaskCount(
                sections[sectionIndex].tasks.length,
              ),
            ),
            const SizedBox(height: 8),
            for (
              var index = 0;
              index < sections[sectionIndex].tasks.length;
              index++
            ) ...[
              TaskListItem(
                task: sections[sectionIndex].tasks[index],
                isSelected:
                    sections[sectionIndex].tasks[index].id == selectedTaskId,
                assigneeName: assigneeName(
                  context,
                  sections[sectionIndex].tasks[index].assigneeProfileId,
                  members,
                  currentProfileId: currentProfileId,
                ),
                assigneeMember: memberForProfileId(
                  sections[sectionIndex].tasks[index].assigneeProfileId,
                  members,
                ),
                isCompletingTask: isCompletingTask,
                isOffline: isOffline,
                onTap: () =>
                    onSelectTask(sections[sectionIndex].tasks[index].id),
                onComplete:
                    sections[sectionIndex].tasks[index].status == 'completed'
                    ? null
                    : () async {
                        await onCompleteTask(
                          sections[sectionIndex].tasks[index],
                        );
                      },
              ),
              if (index != sections[sectionIndex].tasks.length - 1)
                const SizedBox(height: 8),
            ],
            if (sectionIndex != sections.length - 1) const SizedBox(height: 16),
          ],
      ],
    );
  }
}
