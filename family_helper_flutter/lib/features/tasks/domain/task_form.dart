class TaskForm {
  const TaskForm({
    required this.title,
    required this.isPersonal,
    this.dueAt,
    this.recurringOnComplete = false,
  });

  final String title;
  final bool isPersonal;
  final DateTime? dueAt;
  final bool recurringOnComplete;
}
