import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/family_member_avatar.dart';
import 'task_workspace_utils.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    required this.isSelected,
    required this.assigneeName,
    required this.assigneeMember,
    required this.isCompletingTask,
    required this.isOffline,
    required this.onTap,
    required this.onComplete,
  });

  final TaskDto task;
  final bool isSelected;
  final String assigneeName;
  final FamilyMemberDto? assigneeMember;
  final bool isCompletingTask;
  final bool isOffline;
  final VoidCallback onTap;
  final Future<void> Function()? onComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? context.colors.surfaceMuted : null,
      child: ListTile(
        key: Key('task-list-item-${task.id}'),
        onTap: onTap,
        leading: assigneeMember == null
            ? null
            : FamilyMemberAvatar(
                displayName: assigneeMember!.displayName,
                avatarMediaId: assigneeMember!.avatarMediaId,
                size: 36,
              ),
        title: Text(task.title),
        subtitle: Text(
          '$assigneeName • ${priorityLabel(context, task.priority)} • ${shortDueLabel(context, task)}',
        ),
        trailing: task.status == 'completed'
            ? const Icon(Icons.archive_outlined)
            : Checkbox(
                value: false,
                onChanged: isCompletingTask || isOffline || onComplete == null
                    ? null
                    : (_) async {
                        await onComplete!();
                      },
              ),
      ),
    );
  }
}
