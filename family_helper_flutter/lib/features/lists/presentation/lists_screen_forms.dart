part of 'lists_screen.dart';

class _CreateListSheet extends StatefulWidget {
  const _CreateListSheet({
    required this.onSubmit,
    this.initialTitle,
    this.initialType = 'shopping',
    this.sheetTitle = 'Create a new list',
    this.submitLabel = 'Create list',
    this.useModalShell = true,
  });

  final Future<void> Function(String title, String type) onSubmit;
  final String? initialTitle;
  final String initialType;
  final String sheetTitle;
  final String submitLabel;
  final bool useModalShell;

  @override
  State<_CreateListSheet> createState() => _CreateListSheetState();
}

class _CreateListSheetState extends State<_CreateListSheet> {
  late final TextEditingController _titleController;
  late String _selectedType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SheetScaffold(
      useModalShell: widget.useModalShell,
      title: widget.sheetTitle,
      subtitle: l10n.listsCreateSheetSubtitle,
      child: Column(
        children: [
          AppTextField(
            controller: _titleController,
            label: l10n.listsListTitleLabel,
            hint: l10n.listsListTitleHint,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final type in const ['shopping', 'wishlist'])
                ChoiceChip(
                  selected: _selectedType == type,
                  label: Text(_ListSpec.labelFor(context, type)),
                  avatar: Icon(_ListSpec.iconFor(type), size: 18),
                  onSelected: (_) => setState(() {
                    _selectedType = type;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            label: widget.submitLabel,
            onPressed: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    try {
      await widget.onSubmit(title, _selectedType);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet({
    required this.listTitle,
    required this.onSubmit,
    this.initialItem,
    this.sheetTitle = 'Add item',
    this.submitLabel = 'Add to list',
    this.useModalShell = true,
  });

  final String listTitle;
  final ListItemDto? initialItem;
  final String sheetTitle;
  final String submitLabel;
  final bool useModalShell;
  final Future<void> Function({
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
  })
  onSubmit;

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _qtyController;
  late final TextEditingController _unitController;
  late final TextEditingController _noteController;
  late final TextEditingController _priceController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _titleController = TextEditingController(text: item?.title ?? '');
    _qtyController = TextEditingController(text: '${item?.qty ?? 1}');
    _unitController = TextEditingController(text: item?.unit ?? '');
    _noteController = TextEditingController(text: item?.note ?? '');
    _priceController = TextEditingController(
      text: item?.priceCents == null
          ? ''
          : (item!.priceCents! / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SheetScaffold(
      useModalShell: widget.useModalShell,
      title: widget.sheetTitle,
      subtitle: l10n.listsAddItemSubtitle(widget.listTitle),
      child: Column(
        children: [
          AppTextField(
            controller: _titleController,
            label: l10n.listsItemTitleLabel,
            hint: l10n.listsItemTitleHint,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _qtyController,
                  label: l10n.listsQtyLabel,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _unitController,
                  label: l10n.listsUnitLabel,
                  hint: l10n.listsUnitHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _noteController,
            label: l10n.commonNote,
            hint: l10n.listsNoteHint,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _priceController,
            label: l10n.listsPriceLabel,
            hint: '249.90',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          AppButton(
            label: widget.submitLabel,
            onPressed: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _isSubmitting) {
      return;
    }

    final qtyText = _qtyController.text.trim();
    final qty = qtyText.isEmpty
        ? 1.0
        : double.tryParse(qtyText.replaceAll(',', '.'));
    if (qty == null || qty <= 0) {
      return;
    }

    final priceCents = _parsePriceToCents(_priceController.text.trim());
    if (_priceController.text.trim().isNotEmpty && priceCents == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    try {
      await widget.onSubmit(
        title: title,
        qty: qty,
        unit: _normalizeOptional(_unitController.text),
        note: _normalizeOptional(_noteController.text),
        priceCents: priceCents,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? _normalizeOptional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  int? _parsePriceToCents(String value) {
    if (value.isEmpty) {
      return null;
    }
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed < 0) {
      return null;
    }
    return (parsed * 100).round();
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    this.useModalShell = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool useModalShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        child,
      ],
    );

    if (useModalShell) {
      return AppModalSheet(
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: content,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: content,
    );
  }
}
