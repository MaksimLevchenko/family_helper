import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';
import 'money_goal_formatters.dart';

class MoneyGoalCreateForm extends StatefulWidget {
  const MoneyGoalCreateForm({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final Future<bool> Function({
    required String title,
    required int targetAmountCents,
  })
  onSubmit;

  @override
  State<MoneyGoalCreateForm> createState() => _MoneyGoalCreateFormState();
}

class _MoneyGoalCreateFormState extends State<MoneyGoalCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create a new goal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a title and the target amount in standard money format.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _MoneyGoalTitleField(
            controller: _titleController,
            fieldKey: const Key('create-goal-title-field'),
          ),
          const SizedBox(height: 12),
          _MoneyGoalAmountField(
            controller: _amountController,
            fieldKey: const Key('create-goal-amount-field'),
            labelText: 'Target amount',
            hintText: '1500.00',
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Create goal',
            isLoading: widget.isSubmitting,
            onPressed: widget.isSubmitting ? null : _submit,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final didCreate = await widget.onSubmit(
      title: _titleController.text.trim(),
      targetAmountCents: parseMoneyInputToCents(_amountController.text.trim())!,
    );
    if (!mounted || !didCreate) {
      return;
    }
    Navigator.of(context).pop();
  }
}

class MoneyGoalSettingsForm extends StatefulWidget {
  const MoneyGoalSettingsForm({
    super.key,
    required this.goal,
    required this.isSubmitting,
    required this.onSubmit,
    this.isReadOnly = false,
  });

  final MoneyGoalDto goal;
  final bool isSubmitting;
  final bool isReadOnly;
  final Future<bool> Function({
    required String title,
    required int targetAmountCents,
    String? description,
    DateTime? deadlineAt,
    required String currency,
  })
  onSubmit;

  @override
  State<MoneyGoalSettingsForm> createState() => _MoneyGoalSettingsFormState();
}

class _MoneyGoalSettingsFormState extends State<MoneyGoalSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  DateTime? _deadlineAt;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _syncFromGoal();
  }

  @override
  void didUpdateWidget(covariant MoneyGoalSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.id != widget.goal.id ||
        oldWidget.goal.version != widget.goal.version) {
      _syncFromGoal();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isReadOnly) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Archived goals stay visible, but their settings can no longer be edited.',
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _MoneyGoalTitleField(
            controller: _titleController,
            fieldKey: const Key('goal-settings-title-field'),
            enabled: !widget.isReadOnly,
          ),
          const SizedBox(height: 10),
          _MoneyGoalAmountField(
            controller: _amountController,
            fieldKey: const Key('goal-settings-amount-field'),
            labelText: 'Target amount',
            hintText: '1500.00',
            enabled: !widget.isReadOnly,
          ),
          const SizedBox(height: 10),
          TextFormField(
            key: const Key('goal-settings-description-field'),
            controller: _descriptionController,
            enabled: !widget.isReadOnly,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Optional note for the family',
            ),
          ),
          const SizedBox(height: 10),
          _DeadlineField(
            deadlineAt: _deadlineAt,
            enabled: !widget.isReadOnly,
            onPick: _pickDeadline,
            onClear: () {
              setState(() {
                _deadlineAt = null;
              });
            },
          ),
          if (!widget.isReadOnly) ...[
            const SizedBox(height: 16),
            AppButton(
              label: 'Save changes',
              isLoading: widget.isSubmitting,
              onPressed: widget.isSubmitting ? null : _submit,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final initialDate = _deadlineAt ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 20),
    );
    if (!mounted || pickedDate == null) {
      return;
    }
    setState(() {
      _deadlineAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.onSubmit(
      title: _titleController.text.trim(),
      targetAmountCents: parseMoneyInputToCents(_amountController.text.trim())!,
      description: _descriptionController.text,
      deadlineAt: _deadlineAt,
      currency: widget.goal.currency,
    );
  }

  void _syncFromGoal() {
    _titleController.text = widget.goal.title;
    _amountController.text = _formatMoneyInput(widget.goal.targetAmountCents);
    _descriptionController.text = widget.goal.description ?? '';
    _deadlineAt = widget.goal.deadlineAt;
  }
}

class MoneyGoalContributionForm extends StatelessWidget {
  const MoneyGoalContributionForm({
    super.key,
    required this.goalTitle,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final String goalTitle;
  final bool isSubmitting;
  final Future<bool> Function({required int amountCents}) onSubmit;

  @override
  Widget build(BuildContext context) {
    return _MoneyGoalAmountForm(
      title: 'Add contribution',
      description: 'Top up "$goalTitle" with a one-time contribution.',
      fieldKey: const Key('add-contribution-amount-field'),
      fieldLabel: 'Contribution amount',
      buttonLabel: 'Add contribution',
      isSubmitting: isSubmitting,
      onSubmit: onSubmit,
    );
  }
}

class MoneyGoalWithdrawForm extends StatelessWidget {
  const MoneyGoalWithdrawForm({
    super.key,
    required this.goalTitle,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final String goalTitle;
  final bool isSubmitting;
  final Future<bool> Function({required int amountCents}) onSubmit;

  @override
  Widget build(BuildContext context) {
    return _MoneyGoalAmountForm(
      title: 'Withdraw money',
      description: 'Take money back from "$goalTitle".',
      fieldKey: const Key('withdraw-goal-amount-field'),
      fieldLabel: 'Withdraw amount',
      buttonLabel: 'Withdraw money',
      isSubmitting: isSubmitting,
      onSubmit: onSubmit,
    );
  }
}

class MoneyGoalConfirmAction extends StatelessWidget {
  const MoneyGoalConfirmAction({
    super.key,
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        AppButton(
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

class _MoneyGoalAmountForm extends StatefulWidget {
  const _MoneyGoalAmountForm({
    required this.title,
    required this.description,
    required this.fieldKey,
    required this.fieldLabel,
    required this.buttonLabel,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final String title;
  final String description;
  final Key fieldKey;
  final String fieldLabel;
  final String buttonLabel;
  final bool isSubmitting;
  final Future<bool> Function({required int amountCents}) onSubmit;

  @override
  State<_MoneyGoalAmountForm> createState() => _MoneyGoalAmountFormState();
}

class _MoneyGoalAmountFormState extends State<_MoneyGoalAmountForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _MoneyGoalAmountField(
            controller: _amountController,
            fieldKey: widget.fieldKey,
            labelText: widget.fieldLabel,
            hintText: '250.00',
          ),
          const SizedBox(height: 20),
          AppButton(
            label: widget.buttonLabel,
            isLoading: widget.isSubmitting,
            onPressed: widget.isSubmitting ? null : _submit,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final didSubmit = await widget.onSubmit(
      amountCents: parseMoneyInputToCents(_amountController.text.trim())!,
    );
    if (!mounted || !didSubmit) {
      return;
    }
    Navigator.of(context).pop();
  }
}

class _MoneyGoalTitleField extends StatelessWidget {
  const _MoneyGoalTitleField({
    required this.controller,
    required this.fieldKey,
    this.enabled = true,
  });

  final TextEditingController controller;
  final Key fieldKey;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Goal title',
        hintText: 'Emergency fund',
      ),
      validator: _titleValidator,
    );
  }
}

class _MoneyGoalAmountField extends StatelessWidget {
  const _MoneyGoalAmountField({
    required this.controller,
    required this.fieldKey,
    required this.labelText,
    required this.hintText,
    this.enabled = true,
  });

  final TextEditingController controller;
  final Key fieldKey;
  final String labelText;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      validator: _amountValidator,
    );
  }
}

class _DeadlineField extends StatelessWidget {
  const _DeadlineField({
    required this.deadlineAt,
    required this.enabled,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? deadlineAt;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deadline',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          Text(
            deadlineAt == null
                ? 'No deadline set'
                : formatShortDate(deadlineAt!),
            style: TextStyle(color: context.colors.textSecondary),
          ),
          if (enabled) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  key: const Key('goal-settings-pick-deadline-button'),
                  onPressed: onPick,
                  child: const Text('Pick date'),
                ),
                if (deadlineAt != null)
                  TextButton(
                    key: const Key('goal-settings-clear-deadline-button'),
                    onPressed: onClear,
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

String? _titleValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Enter a goal title';
  }
  return null;
}

String? _amountValidator(String? value) {
  final amountCents = parseMoneyInputToCents(value ?? '');
  if (amountCents == null || amountCents <= 0) {
    return 'Enter a valid amount';
  }
  return null;
}

String _formatMoneyInput(int amountCents) {
  final units = amountCents ~/ 100;
  final decimals = (amountCents % 100).toString().padLeft(2, '0');
  return '$units.$decimals';
}
