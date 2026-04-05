import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'task_workspace_utils.dart';

class HistoryRow extends StatelessWidget {
  const HistoryRow({super.key, required this.entry});

  final TaskHistoryEntryDto entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: context.colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${entry.actorDisplayName} • ${historyLabel(context, entry.eventType)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(entry.details),
              const SizedBox(height: 4),
              Text(
                formatTaskDateTime(context, entry.createdAt),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
