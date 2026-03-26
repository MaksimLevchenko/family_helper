import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/server_availability_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../family_invites/providers/family_provider.dart';
import '../providers/lists_provider.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    final familyState = context.watch<FamilyMembersCubit?>()?.state;
    final colors = context.colors;

    return BlocBuilder<ListsCubit, ListsState>(
      builder: (context, state) {
        final selectedList = state.selectedList;

        return Scaffold(
          backgroundColor: colors.background,
          appBar: serverStatusAppBar(context, title: const Text('Lists')),
          floatingActionButton: selectedList == null
              ? null
              : FloatingActionButton.extended(
                  onPressed: isOffline
                      ? null
                      : () {
                          _showAddItemSheet(context, selectedList);
                        },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add item'),
                ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ListsCubit>().reload(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
                children: [
                  CachedDataStatus(
                    isUsingCachedData: state.isUsingCachedData,
                    lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
                  ),
                  if (state.error != null) ...[
                    AppBanner(text: state.error!, isError: true),
                    const SizedBox(height: 12),
                  ],
                  _HeroCard(
                    familyTitle:
                        familyState?.family?.title ?? 'Family collaboration',
                    listCount: state.lists.length,
                    isOffline: isOffline,
                    onCreateList: () {
                      _showCreateListSheet(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  _HeaderRow(
                    title: 'Your lists',
                    subtitle: 'Pick a list and keep every check-off visible.',
                    trailing: state.isLoadingLists && state.lists.isNotEmpty
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  if (state.lists.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const EmptyState(
                              title: 'No lists yet',
                              message:
                                  'Start with a shopping list or wishlist for your family.',
                            ),
                            const SizedBox(height: 16),
                            AppButton(
                              label: 'Create your first list',
                              onPressed: isOffline
                                  ? null
                                  : () {
                                      _showCreateListSheet(context);
                                    },
                              isLoading: state.isLoadingLists,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 212,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.lists.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final list = state.lists[index];
                          return _ListCard(
                            list: list,
                            isSelected: list.id == state.selectedListId,
                            onTap: () {
                              context.read<ListsCubit>().selectList(list.id);
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  _HeaderRow(
                    title: selectedList?.title ?? 'List details',
                    subtitle: selectedList == null
                        ? 'Choose or create a list to start adding items.'
                        : _selectedListSubtitle(selectedList),
                    trailing: selectedList == null
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _TypeBadge(type: selectedList.listType),
                              if (!isOffline) ...[
                                const SizedBox(width: 8),
                                PopupMenuButton<_SelectedListAction>(
                                  tooltip: 'List actions',
                                  onSelected: (action) {
                                    _handleSelectedListAction(
                                      context,
                                      selectedList,
                                      action,
                                    );
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: _SelectedListAction.edit,
                                      child: Text('Edit list'),
                                    ),
                                    PopupMenuItem(
                                      value: _SelectedListAction.delete,
                                      child: Text('Delete list'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                  ),
                  const SizedBox(height: 12),
                  if (selectedList == null)
                    const EmptyState(
                      title: 'No list selected',
                      message:
                          'Create your first list to start planning together.',
                    )
                  else
                    _ListDetails(
                      list: selectedList,
                      items: state.items,
                      isOffline: isOffline,
                      isLoadingItems: state.isLoadingItems,
                      pendingActionItemId: state.pendingActionItemId,
                      onAddItem: () {
                        _showAddItemSheet(context, selectedList);
                      },
                      onEditItem: (item) {
                        _showAddItemSheet(
                          context,
                          selectedList,
                          initialItem: item,
                        );
                      },
                      onDeleteItem: (item) {
                        _confirmDeleteItem(context, item);
                      },
                      onToggleBought: (item) {
                        context.read<ListsCubit>().toggleBought(item);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCreateListSheet(
    BuildContext context, {
    FamilyListDto? initialList,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateListSheet(
        initialTitle: initialList?.title,
        initialType: initialList?.listType ?? 'shopping',
        sheetTitle: initialList == null ? 'Create a new list' : 'Edit list',
        submitLabel: initialList == null ? 'Create list' : 'Save changes',
        onSubmit: (title, type) async {
          if (initialList == null) {
            await context.read<ListsCubit>().createList(title, listType: type);
          } else {
            await context.read<ListsCubit>().updateSelectedList(
              title: title,
              listType: type,
            );
          }
        },
      ),
    );
  }

  Future<void> _showAddItemSheet(
    BuildContext context,
    FamilyListDto selectedList, {
    ListItemDto? initialItem,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddItemSheet(
        listTitle: selectedList.title,
        initialItem: initialItem,
        sheetTitle: initialItem == null ? 'Add item' : 'Edit item',
        submitLabel: initialItem == null ? 'Add to list' : 'Save changes',
        onSubmit:
            ({
              required String title,
              required double qty,
              String? unit,
              String? note,
              int? priceCents,
            }) async {
              if (initialItem == null) {
                await context.read<ListsCubit>().addItem(
                  title: title,
                  qty: qty,
                  unit: unit,
                  note: note,
                  priceCents: priceCents,
                );
              } else {
                await context.read<ListsCubit>().updateItem(
                  initialItem,
                  title: title,
                  qty: qty,
                  unit: unit,
                  note: note,
                  priceCents: priceCents,
                );
              }
            },
      ),
    );
  }

  Future<void> _handleSelectedListAction(
    BuildContext context,
    FamilyListDto list,
    _SelectedListAction action,
  ) async {
    switch (action) {
      case _SelectedListAction.edit:
        await _showCreateListSheet(context, initialList: list);
      case _SelectedListAction.delete:
        await _confirmDeleteList(context, list);
    }
  }

  Future<void> _confirmDeleteList(
    BuildContext context,
    FamilyListDto list,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text('This will remove ${list.title} and all of its items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ListsCubit>().deleteSelectedList();
    }
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    ListItemDto item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Remove ${item.title} from this list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ListsCubit>().deleteItem(item);
    }
  }
}

enum _SelectedListAction { edit, delete }

enum _ItemAction { edit, delete }

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.familyTitle,
    required this.listCount,
    required this.isOffline,
    required this.onCreateList,
  });

  final String familyTitle;
  final int listCount;
  final bool isOffline;
  final VoidCallback onCreateList;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.96),
            colors.secondary.withValues(alpha: 0.84),
            colors.surfaceMuted.withValues(alpha: 0.92),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              familyTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Shared lists that feel alive.',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            listCount == 0
                ? 'Create your first shopping or wishlist board and keep every check-off visible.'
                : '$listCount active list${listCount == 1 ? '' : 's'} with clear ownership.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: isOffline ? null : onCreateList,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colors.primary,
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('New list'),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.list,
    required this.isSelected,
    required this.onTap,
  });

  final FamilyListDto list;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spec = _ListSpec.fromType(list.listType, colors, isDark: isDark);
    final iconBackgroundColor = isDark
        ? Colors.white.withValues(alpha: isSelected ? 0.16 : 0.10)
        : Colors.white.withValues(alpha: isSelected ? 0.2 : 0.62);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected ? spec.selectedGradient : spec.idleGradient,
        ),
        border: Border.all(
          color: isSelected
              ? spec.accent.withValues(alpha: isDark ? 0.95 : 0.8)
              : colors.border.withValues(alpha: isDark ? 0.72 : 1),
        ),
        boxShadow: [
          BoxShadow(
            color: spec.accent.withValues(
              alpha: isDark
                  ? (isSelected ? 0.18 : 0.10)
                  : (isSelected ? 0.22 : 0.08),
            ),
            blurRadius: isSelected ? 24 : 12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(spec.icon, color: spec.iconColor),
                  ),
                  const Spacer(),
                  _TypeBadge(type: list.listType),
                ],
              ),
              const Spacer(),
              Text(
                list.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: spec.textColor,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricBlock(
                      label: 'Open',
                      value: '${list.pendingItemsCount ?? 0}',
                      textColor: spec.textColor,
                    ),
                  ),
                  Expanded(
                    child: _MetricBlock(
                      label: 'Updated',
                      value: _formatCompactDate(context, list.updatedAt),
                      textColor: spec.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    required this.textColor,
  });

  final String label;
  final String value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: textColor.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ListDetails extends StatelessWidget {
  const _ListDetails({
    required this.list,
    required this.items,
    required this.isOffline,
    required this.isLoadingItems,
    required this.pendingActionItemId,
    required this.onAddItem,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onToggleBought,
  });

  final FamilyListDto list;
  final List<ListItemDto> items;
  final bool isOffline;
  final bool isLoadingItems;
  final int? pendingActionItemId;
  final VoidCallback onAddItem;
  final ValueChanged<ListItemDto> onEditItem;
  final ValueChanged<ListItemDto> onDeleteItem;
  final ValueChanged<ListItemDto> onToggleBought;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spec = _ListSpec.fromType(list.listType, colors, isDark: isDark);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: isDark ? 0.94 : 0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  items.isEmpty
                      ? 'Start with your first item'
                      : '${items.where((item) => !item.isBought).length} items still open',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              if (isLoadingItems && items.isNotEmpty)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoadingItems && items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: LoadingState()),
            )
          else if (items.isEmpty)
            Column(
              children: [
                EmptyState(
                  title: 'This list is ready',
                  message:
                      'Add the first item to ${list.title} and make it visible to everyone.',
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Add first item',
                  onPressed: isOffline ? null : onAddItem,
                ),
              ],
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ItemCard(
                  item: item,
                  accentColor: spec.accent,
                  isOffline: isOffline,
                  isPending: pendingActionItemId == item.id,
                  onToggleBought: () => onToggleBought(item),
                  onEdit: () => onEditItem(item),
                  onDelete: () => onDeleteItem(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.accentColor,
    required this.isOffline,
    required this.isPending,
    required this.onToggleBought,
    required this.onEdit,
    required this.onDelete,
  });

  final ListItemDto item;
  final Color accentColor;
  final bool isOffline;
  final bool isPending;
  final VoidCallback onToggleBought;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isBought = item.isBought;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isBought
          ? accentColor.withValues(alpha: isDark ? 0.16 : 0.08)
          : (isDark
                ? colors.surfaceMuted.withValues(alpha: 0.92)
                : colors.background.withValues(alpha: 0.62)),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: isOffline || isPending ? null : onToggleBought,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary.withValues(
                          alpha: isBought ? 0.68 : 1,
                        ),
                        fontWeight: FontWeight.w700,
                        decoration: isBought
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: colors.textSecondary,
                      ),
                    ),
                    if (_itemMetaLine(item) case final meta
                        when meta != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        meta,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                    if (isBought && item.boughtByDisplayName != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Marked by ${item.boughtByDisplayName} - ${_formatDateTime(context, item.boughtAt)}',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: colors.textPrimary,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  if (!isOffline)
                    PopupMenuButton<_ItemAction>(
                      tooltip: 'Item actions',
                      onSelected: (action) {
                        switch (action) {
                          case _ItemAction.edit:
                            onEdit();
                          case _ItemAction.delete:
                            onDelete();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: _ItemAction.edit,
                          child: Text('Edit item'),
                        ),
                        PopupMenuItem(
                          value: _ItemAction.delete,
                          child: Text('Delete item'),
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 40),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: isPending
                        ? const CircularProgressIndicator(strokeWidth: 2.4)
                        : Checkbox(
                            value: isBought,
                            onChanged: isOffline
                                ? null
                                : (_) => onToggleBought(),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spec = _ListSpec.fromType(type, colors, isDark: isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: spec.badgeColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        spec.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: spec.badgeTextColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CreateListSheet extends StatefulWidget {
  const _CreateListSheet({
    required this.onSubmit,
    this.initialTitle,
    this.initialType = 'shopping',
    this.sheetTitle = 'Create a new list',
    this.submitLabel = 'Create list',
  });

  final Future<void> Function(String title, String type) onSubmit;
  final String? initialTitle;
  final String initialType;
  final String sheetTitle;
  final String submitLabel;

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
    return _SheetScaffold(
      title: widget.sheetTitle,
      subtitle:
          'Choose a template and make it easy for the whole family to follow.',
      child: Column(
        children: [
          AppTextField(
            controller: _titleController,
            label: 'List title',
            hint: 'Saturday groceries',
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
                  label: Text(_ListSpec.labelFor(type)),
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
  });

  final String listTitle;
  final ListItemDto? initialItem;
  final String sheetTitle;
  final String submitLabel;
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
    return _SheetScaffold(
      title: widget.sheetTitle,
      subtitle: 'Everything added here will show up in ${widget.listTitle}.',
      child: Column(
        children: [
          AppTextField(
            controller: _titleController,
            label: 'Item title',
            hint: 'Milk',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _qtyController,
                  label: 'Qty',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _unitController,
                  label: 'Unit',
                  hint: 'pcs / kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _noteController,
            label: 'Note',
            hint: 'Semi-skimmed if available',
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _priceController,
            label: 'Price',
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
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppModalSheet(
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
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
      ),
    );
  }
}

class _ListSpec {
  const _ListSpec({
    required this.label,
    required this.icon,
    required this.accent,
    required this.iconColor,
    required this.textColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.selectedGradient,
    required this.idleGradient,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final Color iconColor;
  final Color textColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final List<Color> selectedGradient;
  final List<Color> idleGradient;

  static _ListSpec fromType(
    String type,
    AppColors colors, {
    required bool isDark,
  }) {
    switch (type) {
      case 'wishlist':
        return _ListSpec(
          label: 'Wishlist',
          icon: Icons.auto_awesome_rounded,
          accent: Colors.deepOrange,
          iconColor: isDark
              ? Colors.orange.shade100
              : Colors.deepOrange.shade700,
          textColor: colors.textPrimary,
          badgeColor: isDark
              ? _tintSurface(colors.surface, Colors.deepOrange, 0.24)
              : Colors.deepOrange.withValues(alpha: 0.14),
          badgeTextColor: isDark
              ? Colors.orange.shade100
              : Colors.deepOrange.shade700,
          selectedGradient: isDark
              ? [
                  _tintSurface(colors.surface, Colors.deepOrange, 0.42),
                  _tintSurface(colors.surfaceMuted, Colors.orange, 0.28),
                  _tintSurface(colors.surface, Colors.deepOrange, 0.16),
                ]
              : [
                  Colors.orange.shade100,
                  Colors.deepOrange.shade100,
                  Colors.white,
                ],
          idleGradient: isDark
              ? [
                  _tintSurface(colors.surface, Colors.deepOrange, 0.20),
                  _tintSurface(colors.surfaceMuted, Colors.orange, 0.12),
                  colors.surface,
                ]
              : [
                  Colors.white,
                  Colors.orange.shade50,
                  colors.surfaceMuted,
                ],
        );
      case 'shopping':
      default:
        return _ListSpec(
          label: 'Shopping',
          icon: Icons.local_grocery_store_rounded,
          accent: Colors.teal,
          iconColor: isDark ? Colors.teal.shade100 : Colors.teal.shade700,
          textColor: colors.textPrimary,
          badgeColor: isDark
              ? _tintSurface(colors.surface, Colors.teal, 0.24)
              : Colors.teal.withValues(alpha: 0.14),
          badgeTextColor: isDark ? Colors.teal.shade100 : Colors.teal.shade700,
          selectedGradient: isDark
              ? [
                  _tintSurface(colors.surface, Colors.teal, 0.44),
                  _tintSurface(colors.surfaceMuted, Colors.cyan, 0.24),
                  _tintSurface(colors.surface, Colors.teal, 0.14),
                ]
              : [
                  Colors.teal.shade100,
                  Colors.cyan.shade50,
                  Colors.white,
                ],
          idleGradient: isDark
              ? [
                  _tintSurface(colors.surface, Colors.teal, 0.20),
                  _tintSurface(colors.surfaceMuted, Colors.cyan, 0.10),
                  colors.surface,
                ]
              : [
                  Colors.white,
                  Colors.teal.shade50,
                  colors.surfaceMuted,
                ],
        );
    }
  }

  static Color _tintSurface(Color base, Color tint, double opacity) {
    return Color.alphaBlend(tint.withValues(alpha: opacity), base);
  }

  static String labelFor(String type) => switch (type) {
    'wishlist' => 'Wishlist',
    _ => 'Shopping',
  };

  static IconData iconFor(String type) => switch (type) {
    'wishlist' => Icons.auto_awesome_rounded,
    _ => Icons.local_grocery_store_rounded,
  };
}

String _selectedListSubtitle(FamilyListDto list) {
  final count = list.pendingItemsCount ?? 0;
  final itemWord = count == 1 ? 'item' : 'items';
  final local = list.updatedAt.toLocal();
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return '$count open $itemWord - updated $time';
}

String? _itemMetaLine(ListItemDto item) {
  final parts = <String>[];
  final qtyText = item.qty == item.qty.roundToDouble()
      ? item.qty.toInt().toString()
      : item.qty.toString();
  if (item.qty > 0) {
    parts.add(item.unit == null ? qtyText : '$qtyText ${item.unit}');
  }
  if (item.note?.isNotEmpty ?? false) {
    parts.add(item.note!);
  }
  return parts.isEmpty ? null : parts.join(' - ');
}

String _formatCompactDate(BuildContext context, DateTime value) {
  return MaterialLocalizations.of(context).formatShortDate(value.toLocal());
}

String _formatDateTime(BuildContext context, DateTime? value) {
  if (value == null) {
    return 'just now';
  }
  final local = value.toLocal();
  final localizations = MaterialLocalizations.of(context);
  return '${localizations.formatShortDate(local)} ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(local))}';
}
