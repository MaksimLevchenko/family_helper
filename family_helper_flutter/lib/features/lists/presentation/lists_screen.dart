import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
import '../../../core/network/server_availability_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../family_invites/providers/family_provider.dart';
import '../providers/lists_provider.dart';

part 'lists_screen_forms.dart';
part 'lists_screen_sections.dart';

const double _listsWideLayoutBreakpoint = 720;
const double _listsMaxWidthBreakpoint = 1100;
const double _listsMaxContentWidth = 1280;
const double _listsSidebarWidth = 340;

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
          appBar: serverStatusAppBar(
            context,
            title: Text(context.l10n.homeLists),
          ),
          floatingActionButton: selectedList == null
              ? null
              : FloatingActionButton.extended(
                  onPressed: isOffline
                      ? null
                      : () => _showAddItemSheet(context, selectedList),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.l10n.listsAddItemTitle),
                ),
          body: _ListsScreenContent(
            state: state,
            familyState: familyState,
            isOffline: isOffline,
            onCreateList: () => _showCreateListSheet(context),
            onAddItem: (list) => _showAddItemSheet(context, list),
            onEditList: (list) =>
                _showCreateListSheet(context, initialList: list),
            onDeleteList: (list) => _confirmDeleteList(context, list),
            onEditItem: (list, item) => _showAddItemSheet(
              context,
              list,
              initialItem: item,
            ),
            onDeleteItem: (item) => _confirmDeleteItem(context, item),
            onToggleBought: (item) {
              context.read<ListsCubit>().toggleBought(item);
            },
          ),
        );
      },
    );
  }

  Future<void> _showCreateListSheet(
    BuildContext context, {
    FamilyListDto? initialList,
  }) async {
    await _showAdaptiveOverlay<void>(
      context,
      maxWidth: 560,
      builder: (context, useModalShell) => _CreateListSheet(
        initialTitle: initialList?.title,
        initialType: initialList?.listType ?? 'shopping',
        sheetTitle: initialList == null
            ? context.l10n.listsCreateSheetTitle
            : context.l10n.listsEditSheetTitle,
        submitLabel: initialList == null
            ? context.l10n.listsCreateListAction
            : context.l10n.commonSaveChanges,
        useModalShell: useModalShell,
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
    await _showAdaptiveOverlay<void>(
      context,
      maxWidth: 560,
      builder: (context, useModalShell) => _AddItemSheet(
        listTitle: selectedList.title,
        initialItem: initialItem,
        sheetTitle: initialItem == null
            ? context.l10n.listsAddItemTitle
            : context.l10n.listsEditItemTitle,
        submitLabel: initialItem == null
            ? context.l10n.listsAddToListAction
            : context.l10n.commonSaveChanges,
        useModalShell: useModalShell,
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

  Future<T?> _showAdaptiveOverlay<T>(
    BuildContext context, {
    required Widget Function(BuildContext context, bool useModalShell) builder,
    required double maxWidth,
  }) {
    final cubit = context.read<ListsCubit>();
    final isWide =
        MediaQuery.sizeOf(context).width >= _listsWideLayoutBreakpoint;
    if (isWide) {
      return showDialog<T>(
        context: context,
        builder: (dialogContext) {
          return BlocProvider<ListsCubit>.value(
            value: cubit,
            child: Builder(
              builder: (overlayContext) => Dialog(
                insetPadding: const EdgeInsets.all(24),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.9,
                  ),
                  child: builder(overlayContext, false),
                ),
              ),
            ),
          );
        },
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider<ListsCubit>.value(
        value: cubit,
        child: Builder(
          builder: (overlayContext) => builder(overlayContext, true),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteList(
    BuildContext context,
    FamilyListDto list,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.listsDeleteListTitle),
        content: Text(context.l10n.listsDeleteListMessage(list.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.commonDelete),
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
        title: Text(context.l10n.listsDeleteItemTitle),
        content: Text(context.l10n.listsDeleteItemMessage(item.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ListsCubit>().deleteItem(item);
    }
  }
}
