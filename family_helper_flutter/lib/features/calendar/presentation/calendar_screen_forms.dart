part of 'calendar_screen.dart';

class _CalendarActionSheet extends StatelessWidget {
  const _CalendarActionSheet({
    required this.instance,
    this.useModalShell = true,
  });

  final CalendarInstanceDto instance;
  final bool useModalShell;

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      useModalShell: useModalShell,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            instance.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            _CalendarFormatters.timeRange(
              context,
              instance.occurrenceStart,
              instance.occurrenceEnd,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          _SheetSection(
            title: context.l10n.calendarActionEditSection,
            children: instance.isRecurring
                ? [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      title: context.l10n.calendarActionEditOccurrence,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editOne),
                    ),
                    _ActionTile(
                      icon: Icons.update_outlined,
                      title: context.l10n.calendarActionEditFollowing,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editFuture),
                    ),
                    _ActionTile(
                      icon: Icons.auto_mode_outlined,
                      title: context.l10n.calendarActionEditWholeSeries,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.editAll),
                    ),
                  ]
                : [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      title: context.l10n.calendarActionEditEvent,
                      onTap: () =>
                          Navigator.of(context).pop(_CalendarAction.editAll),
                    ),
                  ],
          ),
          const SizedBox(height: 14),
          _SheetSection(
            title: context.l10n.calendarActionDeleteSection,
            children: instance.isRecurring
                ? [
                    _ActionTile(
                      icon: Icons.delete_outline,
                      title: context.l10n.calendarActionDeleteOccurrence,
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteOne),
                    ),
                    _ActionTile(
                      icon: Icons.event_busy_outlined,
                      title: context.l10n.calendarActionDeleteFollowing,
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteFuture),
                    ),
                    _ActionTile(
                      icon: Icons.delete_forever_outlined,
                      title: context.l10n.calendarActionDeleteWholeSeries,
                      destructive: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(_CalendarAction.deleteAll),
                    ),
                  ]
                : [
                    _ActionTile(
                      icon: Icons.delete_outline,
                      title: context.l10n.calendarActionDeleteEvent,
                      destructive: true,
                      onTap: () =>
                          Navigator.of(context).pop(_CalendarAction.deleteAll),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

class _SheetSection extends StatelessWidget {
  const _SheetSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.background.withValues(alpha: 0.66),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border.withValues(alpha: 0.84)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = destructive ? colors.danger : colors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: foreground),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

class _CalendarEventEditorSheet extends StatefulWidget {
  const _CalendarEventEditorSheet({
    required this.title,
    required this.submitLabel,
    required this.initialForm,
    required this.allowRecurrence,
    this.useModalShell = true,
  });

  final String title;
  final String submitLabel;
  final CalendarEventForm initialForm;
  final bool allowRecurrence;
  final bool useModalShell;

  @override
  State<_CalendarEventEditorSheet> createState() =>
      _CalendarEventEditorSheetState();
}

class _CalendarEventEditorSheetState extends State<_CalendarEventEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _intervalController;
  late DateTime _startsAt;
  late DateTime _endsAt;
  late CalendarRecurrence _recurrence;
  late ReminderPreset _reminderPreset;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialForm.title);
    _descriptionController = TextEditingController(
      text: widget.initialForm.description ?? '',
    );
    _startsAt = widget.initialForm.startsAt;
    _endsAt = widget.initialForm.endsAt;
    _recurrence = widget.initialForm.recurrence;
    _reminderPreset = widget.initialForm.reminderPreset;
    _intervalController = TextEditingController(
      text: widget.initialForm.recurrence.interval.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);
    final colors = context.colors;
    final bottomPadding = widget.useModalShell ? safeArea.bottom : 0.0;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.useModalShell) ...[
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.allowRecurrence
                          ? context.l10n.calendarEditorRecurringSubtitle
                          : context.l10n.calendarEditorSingleSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.border.withValues(alpha: 0.9)),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16 + bottomPadding),
            child: Column(
              children: [
                _EditorSection(
                  title: context.l10n.calendarEditorBasicsTitle,
                  subtitle: context.l10n.calendarEditorBasicsSubtitle,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: context.l10n.calendarEditorTitleLabel,
                      ),
                      if (widget.allowRecurrence) ...[
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _descriptionController,
                          label: context.l10n.calendarEditorNotesLabel,
                          hint: context.l10n.calendarEditorOptionalHint,
                          maxLines: 3,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditorSection(
                  title: context.l10n.calendarEditorScheduleTitle,
                  subtitle: context.l10n.calendarEditorScheduleSubtitle,
                  child: Column(
                    children: [
                      _DateTimeTile(
                        label: context.l10n.calendarEditorStartsLabel,
                        value: _startsAt,
                        icon: Icons.login_rounded,
                        onTap: () => _pickDateTime(
                          initialValue: _startsAt,
                          onChanged: (value) {
                            final duration = _endsAt.difference(_startsAt);
                            setState(() {
                              _startsAt = value;
                              if (!_endsAt.isAfter(_startsAt)) {
                                _endsAt = _startsAt.add(
                                  duration.isNegative ||
                                          duration == Duration.zero
                                      ? const Duration(hours: 1)
                                      : duration,
                                );
                              }
                              _validationMessage = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DateTimeTile(
                        label: context.l10n.calendarEditorEndsLabel,
                        value: _endsAt,
                        icon: Icons.logout_rounded,
                        onTap: () => _pickDateTime(
                          initialValue: _endsAt,
                          onChanged: (value) {
                            setState(() {
                              _endsAt = value;
                              _validationMessage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditorSection(
                  title: context.l10n.calendarEditorReminderTitle,
                  subtitle: context.l10n.calendarEditorReminderSubtitle,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ReminderPreset.values
                        .map(
                          (preset) => _ChoicePill(
                            label: preset.label(context.l10n),
                            selected: _reminderPreset == preset,
                            onTap: () {
                              setState(() {
                                _reminderPreset = preset;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (widget.allowRecurrence) ...[
                  const SizedBox(height: 16),
                  _EditorSection(
                    title: context.l10n.calendarEditorRepeatTitle,
                    subtitle: context.l10n.calendarEditorRepeatSubtitle,
                    child: Column(
                      children: [
                        ...CalendarRecurrenceMode.values.map((mode) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RecurrenceModeTile(
                              mode: mode,
                              selected: _recurrence.mode == mode,
                              onTap: () => _selectRecurrenceMode(mode),
                            ),
                          );
                        }),
                        if (_recurrence.mode ==
                            CalendarRecurrenceMode.weekly) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.l10n.calendarEditorDaysOfWeekLabel,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(7, (index) {
                              final weekday = index + 1;
                              final selected = _recurrence.weekdays.contains(
                                weekday,
                              );
                              return _ChoicePill(
                                label: _CalendarFormatters.weekdayShort(
                                  context,
                                  weekday,
                                ),
                                selected: selected,
                                onTap: () {
                                  final next = {..._recurrence.weekdays};
                                  if (selected) {
                                    next.remove(weekday);
                                  } else {
                                    next.add(weekday);
                                  }
                                  setState(() {
                                    _recurrence = CalendarRecurrence.weekly(
                                      next.isEmpty ? <int>{weekday} : next,
                                    );
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                        if (_recurrence.mode ==
                            CalendarRecurrenceMode.everyNDays) ...[
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _intervalController,
                            label:
                                context.l10n.calendarEditorRepeatEveryDaysLabel,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            border: Border(
              top: BorderSide(color: colors.border.withValues(alpha: 0.9)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + bottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_validationMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _validationMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.danger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(context.l10n.commonCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: widget.submitLabel,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

    if (widget.useModalShell) {
      return AppModalSheet(
        maxWidth: 720,
        showHandle: false,
        scrollable: false,
        includeBottomSafeArea: false,
        contentPadding: EdgeInsets.zero,
        child: content,
      );
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.82,
      child: content,
    );
  }

  Future<void> _pickDateTime({
    required DateTime initialValue,
    required ValueChanged<DateTime> onChanged,
  }) async {
    final localInitial = initialValue.toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: localInitial,
      firstDate: DateTime(localInitial.year - 5),
      lastDate: DateTime(localInitial.year + 10),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(localInitial),
    );
    if (time == null) {
      return;
    }
    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute).toUtc(),
    );
  }

  void _selectRecurrenceMode(CalendarRecurrenceMode mode) {
    setState(() {
      _validationMessage = null;
      _recurrence = switch (mode) {
        CalendarRecurrenceMode.none => const CalendarRecurrence.none(),
        CalendarRecurrenceMode.yearly => CalendarRecurrence.yearly(),
        CalendarRecurrenceMode.monthly => CalendarRecurrence.monthly(),
        CalendarRecurrenceMode.weekly => CalendarRecurrence.weekly(
          <int>{_startsAt.toLocal().weekday},
        ),
        CalendarRecurrenceMode.everyNDays => CalendarRecurrence.everyNDays(
          int.tryParse(_intervalController.text) ?? 1,
        ),
      };
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _validationMessage = context.l10n.calendarEditorTitleValidation;
      });
      return;
    }
    if (!_endsAt.isAfter(_startsAt)) {
      setState(() {
        _validationMessage = context.l10n.calendarEditorEndAfterStartValidation;
      });
      return;
    }

    var recurrence = _recurrence;
    if (recurrence.mode == CalendarRecurrenceMode.everyNDays) {
      final interval = int.tryParse(_intervalController.text);
      if (interval == null || interval < 1) {
        setState(() {
          _validationMessage = context.l10n.calendarEditorIntervalValidation;
        });
        return;
      }
      recurrence = CalendarRecurrence.everyNDays(interval);
    }

    Navigator.of(context).pop(
      CalendarEventForm(
        title: title,
        description: widget.allowRecurrence
            ? (_descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim())
            : widget.initialForm.description,
        startsAt: _startsAt,
        endsAt: _endsAt,
        recurrence: recurrence,
        reminderPreset: _reminderPreset,
      ),
    );
  }
}

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border.withValues(alpha: 0.84)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.background.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _CalendarFormatters.dateTimeLabel(context, value),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.12)
              : colors.background.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? colors.primary
                : colors.border.withValues(alpha: 0.84),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RecurrenceModeTile extends StatelessWidget {
  const _RecurrenceModeTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final CalendarRecurrenceMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.10)
          : colors.background.withValues(alpha: 0.68),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.border.withValues(alpha: 0.84),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _modeIcon(mode),
                color: selected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _modeTitle(context, mode),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _modeSubtitle(context, mode),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? colors.primary : colors.border,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? colors.primary : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _modeIcon(CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none => Icons.block_rounded,
      CalendarRecurrenceMode.yearly => Icons.event_repeat_rounded,
      CalendarRecurrenceMode.monthly => Icons.calendar_view_month_rounded,
      CalendarRecurrenceMode.weekly => Icons.view_week_rounded,
      CalendarRecurrenceMode.everyNDays => Icons.loop_rounded,
    };
  }

  String _modeTitle(BuildContext context, CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none => context.l10n.calendarRecurrenceNoneTitle,
      CalendarRecurrenceMode.yearly =>
        context.l10n.calendarRecurrenceYearlyTitle,
      CalendarRecurrenceMode.monthly =>
        context.l10n.calendarRecurrenceMonthlyTitle,
      CalendarRecurrenceMode.weekly =>
        context.l10n.calendarRecurrenceWeeklyTitle,
      CalendarRecurrenceMode.everyNDays =>
        context.l10n.calendarRecurrenceEveryNDaysTitle,
    };
  }

  String _modeSubtitle(BuildContext context, CalendarRecurrenceMode mode) {
    return switch (mode) {
      CalendarRecurrenceMode.none =>
        context.l10n.calendarRecurrenceNoneSubtitle,
      CalendarRecurrenceMode.yearly =>
        context.l10n.calendarRecurrenceYearlySubtitle,
      CalendarRecurrenceMode.monthly =>
        context.l10n.calendarRecurrenceMonthlySubtitle,
      CalendarRecurrenceMode.weekly =>
        context.l10n.calendarRecurrenceWeeklySubtitle,
      CalendarRecurrenceMode.everyNDays =>
        context.l10n.calendarRecurrenceEveryNDaysSubtitle,
    };
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({
    required this.child,
    this.useModalShell = true,
  });

  final Widget child;
  final bool useModalShell;

  @override
  Widget build(BuildContext context) {
    if (useModalShell) {
      return AppModalSheet(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: child,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: child,
    );
  }
}

enum _CalendarAction {
  editOne,
  editFuture,
  editAll,
  deleteOne,
  deleteFuture,
  deleteAll,
}

class _CalendarFormatters {
  static String timeOfDay(BuildContext context, DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateFormat.Hm(_locale(context)).format(local);
  }

  static String timeRange(BuildContext context, DateTime start, DateTime end) {
    return '${timeOfDay(context, start)} - ${timeOfDay(context, end)}';
  }

  static String dateTimeLabel(BuildContext context, DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateFormat.yMMMMd(
      _locale(context),
    ).add_Hm().format(local);
  }

  static String weekdayShort(BuildContext context, int weekday) {
    return DateFormat.E(_locale(context)).format(_weekdayDate(weekday));
  }

  static String _locale(BuildContext context) =>
      Localizations.localeOf(context).toLanguageTag();

  static DateTime _weekdayDate(int weekday) =>
      DateTime.utc(2024, 1, weekday.clamp(1, 7));
}
