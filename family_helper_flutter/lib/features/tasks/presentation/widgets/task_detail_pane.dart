import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';
import '../../domain/task_form.dart';
import 'task_history_row.dart';
import 'task_workspace_common_widgets.dart';
import 'task_workspace_utils.dart';

class TaskDetailPane extends StatelessWidget {
  const TaskDetailPane({
    super.key,
    required this.task,
    required this.history,
    required this.isHistoryLoading,
    required this.isBusy,
    required this.members,
    required this.currentProfileId,
    required this.isOffline,
    this.isEmbedded = false,
    required this.onEditTask,
    required this.onCompleteTask,
    required this.onDeleteTask,
  });

  final TaskDto? task;
  final List<TaskHistoryEntryDto> history;
  final bool isHistoryLoading;
  final bool isBusy;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isOffline;
  final bool isEmbedded;
  final VoidCallback? onEditTask;
  final Future<void> Function()? onCompleteTask;
  final Future<void> Function()? onDeleteTask;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Card(
        key: const Key('tasks-empty-detail'),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: _EmptyDetailText(),
        ),
      );
    }

    return Card(
      key: const Key('tasks-detail-card'),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isEmbedded
            ? _TaskDetailContent(
                task: task!,
                history: history,
                isHistoryLoading: isHistoryLoading,
                isBusy: isBusy,
                members: members,
                currentProfileId: currentProfileId,
                isOffline: isOffline,
                onEditTask: onEditTask,
                onCompleteTask: onCompleteTask,
                onDeleteTask: onDeleteTask,
                isEmbedded: true,
              )
            : SizedBox(
                height: double.infinity,
                child: _TaskDetailContent(
                  task: task!,
                  history: history,
                  isHistoryLoading: isHistoryLoading,
                  isBusy: isBusy,
                  members: members,
                  currentProfileId: currentProfileId,
                  isOffline: isOffline,
                  onEditTask: onEditTask,
                  onCompleteTask: onCompleteTask,
                  onDeleteTask: onDeleteTask,
                  isEmbedded: false,
                ),
              ),
      ),
    );
  }
}

class _TaskDetailContent extends StatelessWidget {
  const _TaskDetailContent({
    required this.task,
    required this.history,
    required this.isHistoryLoading,
    required this.isBusy,
    required this.members,
    required this.currentProfileId,
    required this.isOffline,
    required this.onEditTask,
    required this.onCompleteTask,
    required this.onDeleteTask,
    required this.isEmbedded,
  });

  final TaskDto task;
  final List<TaskHistoryEntryDto> history;
  final bool isHistoryLoading;
  final bool isBusy;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isOffline;
  final bool isEmbedded;
  final VoidCallback? onEditTask;
  final Future<void> Function()? onCompleteTask;
  final Future<void> Function()? onDeleteTask;

  @override
  Widget build(BuildContext context) {
    final historyContent = isHistoryLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        : history.isEmpty
        ? EmptyText(
            title: context.l10n.tasksNoHistoryTitle,
            message: context.l10n.tasksNoHistoryMessage,
          )
        : ListView.separated(
            shrinkWrap: isEmbedded,
            physics: isEmbedded
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, _) => const Divider(height: 16),
            itemBuilder: (context, index) {
              return HistoryRow(entry: history[index]);
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.status == 'completed'
                        ? context.l10n.tasksDetailCompletedItem
                        : context.l10n.tasksDetailOpenFamilyTask,
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusBadge(task: task),
          ],
        ),
        if (task.description != null &&
            task.description!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            task.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MetaChip(
              label:
                  '${context.l10n.taskEditorPriorityLabel}: ${priorityLabel(context, task.priority)}',
            ),
            MetaChip(
              label:
                  '${context.l10n.taskEditorAssigneeLabel}: ${assigneeName(context, task.assigneeProfileId, members, currentProfileId: currentProfileId)}',
            ),
            MetaChip(
              label: task.isPersonal
                  ? context.l10n.tasksMetaPersonal
                  : context.l10n.tasksMetaShared,
            ),
            MetaChip(label: dueChipLabel(context, task.dueAt)),
            if (task.recurrenceRrule != null)
              MetaChip(
                label:
                    '${context.l10n.taskEditorRepeatLabel}: ${taskRecurrenceLabel(context, TaskRecurrencePresetX.fromTask(task))}',
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: 160,
              child: AppButton(
                label: context.l10n.tasksActionComplete,
                onPressed: onCompleteTask == null || isBusy || isOffline
                    ? null
                    : () async {
                        await onCompleteTask!();
                      },
              ),
            ),
            SizedBox(
              width: 160,
              child: AppButton(
                label: context.l10n.tasksActionEdit,
                variant: AppButtonVariant.secondary,
                onPressed: onEditTask == null || isBusy ? null : onEditTask,
              ),
            ),
            SizedBox(
              width: 160,
              child: AppButton(
                key: const Key('task-detail-delete-button'),
                label: context.l10n.tasksActionDelete,
                variant: AppButtonVariant.danger,
                onPressed: onDeleteTask == null || isBusy
                    ? null
                    : () async {
                        await onDeleteTask!();
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.tasksHistoryTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        if (isEmbedded) historyContent else Expanded(child: historyContent),
      ],
    );
  }
}

class _EmptyDetailText extends StatelessWidget {
  const _EmptyDetailText();

  @override
  Widget build(BuildContext context) {
    return EmptyText(
      title: context.l10n.tasksPickTaskTitle,
      message: context.l10n.tasksPickTaskMessage,
    );
  }
}
