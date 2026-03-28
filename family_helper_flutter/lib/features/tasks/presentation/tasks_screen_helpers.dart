part of 'tasks_screen.dart';

void _ensureSelection({
  required TasksState state,
  required List<TaskDto> visibleTasks,
  required bool mounted,
  required ValueChanged<int?> onSelectTask,
}) {
  final selected = resolvedSelectedTask(state, visibleTasks);
  final nextTaskId = selected?.id;
  if (nextTaskId == state.currentTaskId) {
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) {
      return;
    }
    onSelectTask(nextTaskId);
  });
}

Future<void> _showDeleteTaskOverlay(
  BuildContext context,
  TaskDto task, {
  required bool isWide,
  required bool isOffline,
}) async {
  if (isOffline) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tasks are unavailable while offline.')),
    );
    return;
  }

  final cubit = context.read<TasksCubit>();
  final content = BlocProvider<TasksCubit>.value(
    value: cubit,
    child: BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return _TaskConfirmAction(
          title: 'Delete task',
          description:
              'Delete "${task.title}" permanently from active tasks and archive.',
          confirmLabel: 'Delete task',
          isLoading: state.isDeletingTask,
          confirmVariant: AppButtonVariant.danger,
          onConfirm: () => context.read<TasksCubit>().deleteCurrentTask(),
        );
      },
    ),
  );

  if (isWide) {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: content,
            ),
          ),
        );
      },
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return AppModalSheet(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: content,
      );
    },
  );
}

class _TaskConfirmAction extends StatelessWidget {
  const _TaskConfirmAction({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.isLoading,
    required this.onConfirm,
    this.confirmVariant = AppButtonVariant.primary,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final bool isLoading;
  final Future<bool> Function() onConfirm;
  final AppButtonVariant confirmVariant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        AppButton(
          key: const Key('task-delete-confirm-button'),
          label: confirmLabel,
          variant: confirmVariant,
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : () async {
                  final didConfirm = await onConfirm();
                  if (!context.mounted || !didConfirm) {
                    return;
                  }
                  Navigator.of(context).pop();
                },
        ),
      ],
    );
  }
}
