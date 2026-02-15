import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui_kit/ui_kit.dart';
import '../providers/lists_provider.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final _listTitleController = TextEditingController();
  final _itemTitleController = TextEditingController();

  @override
  void dispose() {
    _listTitleController.dispose();
    _itemTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lists')),
      body: BlocBuilder<ListsCubit, ListsState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const LoadingState();
          }

          if (state.error != null && state.items.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<ListsCubit>().reload(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppTextField(controller: _listTitleController, label: 'List title'),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create shopping list',
                onPressed: () async {
                  final title = _listTitleController.text.trim();
                  if (title.isEmpty) {
                    return;
                  }
                  await context.read<ListsCubit>().createList(title);
                },
              ),
              const SizedBox(height: 16),
              AppTextField(controller: _itemTitleController, label: 'Item title'),
              const SizedBox(height: 12),
              AppButton(
                label: 'Add item',
                onPressed: () async {
                  final title = _itemTitleController.text.trim();
                  if (title.isEmpty) {
                    return;
                  }
                  await context.read<ListsCubit>().addItem(title: title);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Reorder (reverse)',
                onPressed: () async {
                  await context.read<ListsCubit>().reorderDescending();
                },
                variant: AppButtonVariant.secondary,
              ),
              const SizedBox(height: 24),
              if (state.items.isEmpty)
                const EmptyState(
                  title: 'No list items',
                  message: 'Create list and add items for shopping or wishlist.',
                )
              else
                ...state.items.map(
                  (item) => AppTile(
                    title: item.title,
                    subtitle:
                        'qty: ${item.qty} ${item.unit ?? ''}, bought: ${item.isBought}',
                    trailing: Checkbox(
                      value: item.isBought,
                      onChanged: (_) async {
                        await context.read<ListsCubit>().toggleBought(item);
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
