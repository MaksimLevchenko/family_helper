part of 'lists_screen.dart';

class _ListsScreenContent extends StatelessWidget {
  const _ListsScreenContent({
    required this.state,
    required this.familyState,
    required this.isOffline,
    required this.onCreateList,
    required this.onAddItem,
    required this.onEditList,
    required this.onDeleteList,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onToggleBought,
  });

  final ListsState state;
  final FamilyMembersState? familyState;
  final bool isOffline;
  final VoidCallback onCreateList;
  final ValueChanged<FamilyListDto> onAddItem;
  final ValueChanged<FamilyListDto> onEditList;
  final ValueChanged<FamilyListDto> onDeleteList;
  final void Function(FamilyListDto list, ListItemDto item) onEditItem;
  final ValueChanged<ListItemDto> onDeleteItem;
  final ValueChanged<ListItemDto> onToggleBought;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _listsWideLayoutBreakpoint;
          final maxWidth = constraints.maxWidth >= _listsMaxWidthBreakpoint
              ? _listsMaxContentWidth
              : double.infinity;

          final content = isWide
              ? _ListsWideLayout(
                  state: state,
                  familyState: familyState,
                  isOffline: isOffline,
                  onCreateList: onCreateList,
                  onAddItem: onAddItem,
                  onEditList: onEditList,
                  onDeleteList: onDeleteList,
                  onEditItem: onEditItem,
                  onDeleteItem: onDeleteItem,
                  onToggleBought: onToggleBought,
                )
              : _ListsNarrowLayout(
                  state: state,
                  familyState: familyState,
                  isOffline: isOffline,
                  onCreateList: onCreateList,
                  onAddItem: onAddItem,
                  onEditList: onEditList,
                  onDeleteList: onDeleteList,
                  onEditItem: onEditItem,
                  onDeleteItem: onDeleteItem,
                  onToggleBought: onToggleBought,
                );

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SizedBox(
                height: constraints.maxHeight,
                child: content,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ListsNarrowLayout extends StatelessWidget {
  const _ListsNarrowLayout({
    required this.state,
    required this.familyState,
    required this.isOffline,
    required this.onCreateList,
    required this.onAddItem,
    required this.onEditList,
    required this.onDeleteList,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onToggleBought,
  });

  final ListsState state;
  final FamilyMembersState? familyState;
  final bool isOffline;
  final VoidCallback onCreateList;
  final ValueChanged<FamilyListDto> onAddItem;
  final ValueChanged<FamilyListDto> onEditList;
  final ValueChanged<FamilyListDto> onDeleteList;
  final void Function(FamilyListDto list, ListItemDto item) onEditItem;
  final ValueChanged<ListItemDto> onDeleteItem;
  final ValueChanged<ListItemDto> onToggleBought;

  @override
  Widget build(BuildContext context) {
    final selectedList = state.selectedList;

    return RefreshIndicator(
      onRefresh: () => context.read<ListsCubit>().reload(),
      child: ListView(
        key: const Key('lists-narrow-layout'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
        children: [
          _ListsStatusSection(state: state),
          _HeroCard(
            familyTitle:
                familyState?.family?.title ?? context.l10n.listsFamilyFallback,
            listCount: state.lists.length,
            isOffline: isOffline,
            onCreateList: onCreateList,
          ),
          const SizedBox(height: 20),
          _ListsCollectionHeader(state: state),
          const SizedBox(height: 12),
          _ListsChooser(
            state: state,
            isOffline: isOffline,
            isWide: false,
            onCreateList: onCreateList,
          ),
          const SizedBox(height: 24),
          _ListDetailsHeader(
            selectedList: selectedList,
            isOffline: isOffline,
            onEditList: onEditList,
            onDeleteList: onDeleteList,
          ),
          const SizedBox(height: 12),
          _ListDetailsBody(
            state: state,
            selectedList: selectedList,
            isOffline: isOffline,
            onAddItem: onAddItem,
            onEditItem: onEditItem,
            onDeleteItem: onDeleteItem,
            onToggleBought: onToggleBought,
          ),
        ],
      ),
    );
  }
}

class _ListsWideLayout extends StatelessWidget {
  const _ListsWideLayout({
    required this.state,
    required this.familyState,
    required this.isOffline,
    required this.onCreateList,
    required this.onAddItem,
    required this.onEditList,
    required this.onDeleteList,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onToggleBought,
  });

  final ListsState state;
  final FamilyMembersState? familyState;
  final bool isOffline;
  final VoidCallback onCreateList;
  final ValueChanged<FamilyListDto> onAddItem;
  final ValueChanged<FamilyListDto> onEditList;
  final ValueChanged<FamilyListDto> onDeleteList;
  final void Function(FamilyListDto list, ListItemDto item) onEditItem;
  final ValueChanged<ListItemDto> onDeleteItem;
  final ValueChanged<ListItemDto> onToggleBought;

  @override
  Widget build(BuildContext context) {
    final selectedList = state.selectedList;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        key: const Key('lists-wide-layout'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            key: const Key('lists-sidebar-pane'),
            width: _listsSidebarWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ListsStatusSection(state: state, includeBottomSpacing: true),
                _HeroCard(
                  familyTitle:
                      familyState?.family?.title ??
                      context.l10n.listsFamilyFallback,
                  listCount: state.lists.length,
                  isOffline: isOffline,
                  onCreateList: onCreateList,
                ),
                const SizedBox(height: 20),
                _ListsCollectionHeader(state: state),
                const SizedBox(height: 12),
                Expanded(
                  child: _ListsChooser(
                    state: state,
                    isOffline: isOffline,
                    isWide: true,
                    onCreateList: onCreateList,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              key: const Key('lists-detail-pane'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ListDetailsHeader(
                    selectedList: selectedList,
                    isOffline: isOffline,
                    onEditList: onEditList,
                    onDeleteList: onDeleteList,
                  ),
                  const SizedBox(height: 12),
                  _ListDetailsBody(
                    state: state,
                    selectedList: selectedList,
                    isOffline: isOffline,
                    onAddItem: onAddItem,
                    onEditItem: onEditItem,
                    onDeleteItem: onDeleteItem,
                    onToggleBought: onToggleBought,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListsStatusSection extends StatelessWidget {
  const _ListsStatusSection({
    required this.state,
    this.includeBottomSpacing = false,
  });

  final ListsState state;
  final bool includeBottomSpacing;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      CachedDataStatus(
        isUsingCachedData: state.isUsingCachedData,
        lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
      ),
      if (state.error != null) ...[
        const SizedBox(height: 12),
        AppBanner(
          text: localizeUiError(context, state.error),
          isError: true,
        ),
      ],
    ];

    if (includeBottomSpacing) {
      children.add(const SizedBox(height: 12));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _ListsCollectionHeader extends StatelessWidget {
  const _ListsCollectionHeader({required this.state});

  final ListsState state;

  @override
  Widget build(BuildContext context) {
    return _HeaderRow(
      title: context.l10n.listsYourListsTitle,
      subtitle: context.l10n.listsYourListsSubtitle,
      trailing: state.isLoadingLists && state.lists.isNotEmpty
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
    );
  }
}

class _ListsChooser extends StatelessWidget {
  const _ListsChooser({
    required this.state,
    required this.isOffline,
    required this.isWide,
    required this.onCreateList,
  });

  final ListsState state;
  final bool isOffline;
  final bool isWide;
  final VoidCallback onCreateList;

  @override
  Widget build(BuildContext context) {
    if (state.lists.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: isWide ? MainAxisSize.min : MainAxisSize.max,
            children: [
              EmptyState(
                title: context.l10n.listsEmptyTitle,
                message: context.l10n.listsEmptyMessage,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: context.l10n.listsCreateFirstList,
                onPressed: isOffline ? null : onCreateList,
                isLoading: state.isLoadingLists,
              ),
            ],
          ),
        ),
      );
    }

    if (isWide) {
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: state.lists.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final list = state.lists[index];
          return _ListCard(
            key: Key('list-card-${list.id}'),
            list: list,
            isSelected: list.id == state.selectedListId,
            onTap: () {
              context.read<ListsCubit>().selectList(list.id);
            },
          );
        },
      );
    }

    return SizedBox(
      height: 212,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.lists.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final list = state.lists[index];
          return _ListCard(
            key: Key('list-card-${list.id}'),
            list: list,
            isSelected: list.id == state.selectedListId,
            onTap: () {
              context.read<ListsCubit>().selectList(list.id);
            },
          );
        },
      ),
    );
  }
}

class _ListDetailsHeader extends StatelessWidget {
  const _ListDetailsHeader({
    required this.selectedList,
    required this.isOffline,
    required this.onEditList,
    required this.onDeleteList,
  });

  final FamilyListDto? selectedList;
  final bool isOffline;
  final ValueChanged<FamilyListDto> onEditList;
  final ValueChanged<FamilyListDto> onDeleteList;

  @override
  Widget build(BuildContext context) {
    return _HeaderRow(
      title: selectedList?.title ?? context.l10n.listsDetailsTitle,
      subtitle: selectedList == null
          ? context.l10n.listsDetailsSubtitle
          : _selectedListSubtitle(context, selectedList!),
      trailing: selectedList == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypeBadge(type: selectedList!.listType),
                if (!isOffline) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<_SelectedListAction>(
                    tooltip: context.l10n.listsListActionsTooltip,
                    onSelected: (action) {
                      switch (action) {
                        case _SelectedListAction.edit:
                          onEditList(selectedList!);
                        case _SelectedListAction.delete:
                          onDeleteList(selectedList!);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _SelectedListAction.edit,
                        child: Text(context.l10n.listsEditListAction),
                      ),
                      PopupMenuItem(
                        value: _SelectedListAction.delete,
                        child: Text(context.l10n.listsDeleteListAction),
                      ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}

class _ListDetailsBody extends StatelessWidget {
  const _ListDetailsBody({
    required this.state,
    required this.selectedList,
    required this.isOffline,
    required this.onAddItem,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onToggleBought,
  });

  final ListsState state;
  final FamilyListDto? selectedList;
  final bool isOffline;
  final ValueChanged<FamilyListDto> onAddItem;
  final void Function(FamilyListDto list, ListItemDto item) onEditItem;
  final ValueChanged<ListItemDto> onDeleteItem;
  final ValueChanged<ListItemDto> onToggleBought;

  @override
  Widget build(BuildContext context) {
    if (selectedList == null) {
      return EmptyState(
        title: context.l10n.listsNoSelectionTitle,
        message: context.l10n.listsNoSelectionMessage,
      );
    }

    return _ListDetails(
      list: selectedList!,
      items: state.items,
      isOffline: isOffline,
      isLoadingItems: state.isLoadingItems,
      pendingActionItemId: state.pendingActionItemId,
      onAddItem: () => onAddItem(selectedList!),
      onEditItem: (item) => onEditItem(selectedList!, item),
      onDeleteItem: onDeleteItem,
      onToggleBought: onToggleBought,
    );
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
    final l10n = context.l10n;
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
            l10n.listsHeroTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            listCount == 0
                ? l10n.listsHeroEmptyMessage
                : l10n.listsHeroCountMessage(listCount),
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
            label: Text(l10n.listsNewList),
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
    super.key,
    required this.list,
    required this.isSelected,
    required this.onTap,
  });

  final FamilyListDto list;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spec = _ListSpec.fromType(
      context,
      list.listType,
      colors,
      isDark: isDark,
    );
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
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 28),
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
                      label: l10n.listsMetricOpen,
                      value: '${list.pendingItemsCount ?? 0}',
                      textColor: spec.textColor,
                    ),
                  ),
                  Expanded(
                    child: _MetricBlock(
                      label: l10n.listsMetricUpdated,
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
    final l10n = context.l10n;
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spec = _ListSpec.fromType(
      context,
      list.listType,
      colors,
      isDark: isDark,
    );

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
                      ? l10n.listsStartFirstItem
                      : l10n.listsItemsStillOpen(
                          items.where((item) => !item.isBought).length,
                        ),
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
                  title: l10n.listsReadyTitle,
                  message: l10n.listsReadyMessage(list.title),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: l10n.listsAddFirstItem,
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
                          context.l10n.listsMarkedBy(
                            item.boughtByDisplayName!,
                            _formatDateTime(context, item.boughtAt),
                          ),
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
                      tooltip: context.l10n.listsItemActionsTooltip,
                      onSelected: (action) {
                        switch (action) {
                          case _ItemAction.edit:
                            onEdit();
                          case _ItemAction.delete:
                            onDelete();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: _ItemAction.edit,
                          child: Text(context.l10n.listsEditItemAction),
                        ),
                        PopupMenuItem(
                          value: _ItemAction.delete,
                          child: Text(context.l10n.listsDeleteItemAction),
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
    final spec = _ListSpec.fromType(context, type, colors, isDark: isDark);

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
    BuildContext context,
    String type,
    AppColors colors, {
    required bool isDark,
  }) {
    switch (type) {
      case 'wishlist':
        return _ListSpec(
          label: context.l10n.listsTypeWishlist,
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
          label: context.l10n.listTypeShopping,
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

  static String labelFor(BuildContext context, String type) => switch (type) {
    'wishlist' => context.l10n.listsTypeWishlist,
    _ => context.l10n.listTypeShopping,
  };

  static IconData iconFor(String type) => switch (type) {
    'wishlist' => Icons.auto_awesome_rounded,
    _ => Icons.local_grocery_store_rounded,
  };
}

String _selectedListSubtitle(BuildContext context, FamilyListDto list) {
  final count = list.pendingItemsCount ?? 0;
  final local = list.updatedAt.toLocal();
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return context.l10n.listsSelectedSubtitle(count, time);
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
    return context.l10n.commonJustNow;
  }
  final local = value.toLocal();
  final localizations = MaterialLocalizations.of(context);
  return '${localizations.formatShortDate(local)} ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(local))}';
}
