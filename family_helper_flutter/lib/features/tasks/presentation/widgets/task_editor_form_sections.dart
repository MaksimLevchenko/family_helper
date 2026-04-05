import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../ui_kit/family_member_avatar.dart';
import '../../domain/task_form.dart';

class TaskEditorHeader extends StatelessWidget {
  const TaskEditorHeader({
    super.key,
    required this.isEditing,
  });

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? l10n.taskEditorEditTitle : l10n.taskEditorCreateTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          isEditing
              ? l10n.taskEditorEditSubtitle
              : l10n.taskEditorCreateSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class TaskEditorBasicsSection extends StatelessWidget {
  const TaskEditorBasicsSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.isPersonal,
    required this.priority,
    required this.assigneeProfileId,
    required this.activeMembers,
    required this.loadSignedUrl,
    required this.priorityLabel,
    required this.onPersonalChanged,
    required this.onPriorityChanged,
    required this.onAssigneeChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isPersonal;
  final TaskPriorityOption priority;
  final int? assigneeProfileId;
  final List<FamilyMemberDto> activeMembers;
  final Future<String> Function(int mediaId)? loadSignedUrl;
  final String Function(TaskPriorityOption priority) priorityLabel;
  final ValueChanged<bool> onPersonalChanged;
  final ValueChanged<TaskPriorityOption> onPriorityChanged;
  final ValueChanged<int?> onAssigneeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        TextFormField(
          key: const Key('task-editor-title-field'),
          controller: titleController,
          decoration: InputDecoration(
            labelText: l10n.taskEditorTitleLabel,
            hintText: l10n.taskEditorTitleHint,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.taskEditorTitleValidation;
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('task-editor-description-field'),
          controller: descriptionController,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: l10n.taskEditorDescriptionLabel,
            hintText: l10n.taskEditorDescriptionHint,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: isPersonal,
          title: Text(l10n.taskEditorPersonalTaskLabel),
          subtitle: Text(
            isPersonal
                ? l10n.taskEditorPersonalTaskOn
                : l10n.taskEditorPersonalTaskOff,
          ),
          onChanged: onPersonalChanged,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TaskPriorityOption>(
          key: const Key('task-editor-priority-field'),
          initialValue: priority,
          decoration: InputDecoration(
            labelText: l10n.taskEditorPriorityLabel,
          ),
          items: TaskPriorityOption.values
              .map(
                (priority) => DropdownMenuItem<TaskPriorityOption>(
                  value: priority,
                  child: Text(priorityLabel(priority)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onPriorityChanged(value);
            }
          },
        ),
        if (!isPersonal) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            key: const Key('task-editor-assignee-field'),
            initialValue: assigneeProfileId,
            decoration: InputDecoration(
              labelText: l10n.taskEditorAssigneeLabel,
            ),
            items: [
              DropdownMenuItem<int?>(
                value: null,
                child: Text(l10n.taskEditorUnassigned),
              ),
              ...activeMembers.map(
                (member) => DropdownMenuItem<int?>(
                  value: member.profileId,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FamilyMemberAvatar(
                          displayName: member.displayName,
                          avatarMediaId: member.avatarMediaId,
                          size: 28,
                          loadSignedUrl: loadSignedUrl,
                        ),
                        const SizedBox(width: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 190),
                          child: Text(
                            member.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onAssigneeChanged,
          ),
        ],
      ],
    );
  }
}
