import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/lists/presentation/lists_screen.dart';
import 'package:family_helper_flutter/features/lists/providers/lists_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestListsCubit extends Cubit<ListsState> implements ListsCubit {
  _TestListsCubit({
    required List<FamilyListDto> lists,
    required Map<int, List<ListItemDto>> itemsByList,
    required int selectedListId,
  }) : _itemsByList = itemsByList,
       super(
         ListsState(
           isLoadingLists: false,
           isLoadingItems: false,
           lists: lists,
           selectedListId: selectedListId,
           items: itemsByList[selectedListId] ?? const [],
         ),
       );

  final Map<int, List<ListItemDto>> _itemsByList;

  @override
  Future<void> addItem({
    required String title,
    double qty = 1,
    String? unit,
    String? note,
    int? priceCents,
  }) async {}

  @override
  Future<void> createList(String title, {String listType = 'shopping'}) async {}

  @override
  Future<void> deleteItem(ListItemDto item) async {}

  @override
  Future<void> deleteSelectedList() async {}

  @override
  Future<void> loadItemsForSelectedList({bool showLoading = true}) async {}

  @override
  Future<void> loadLists({
    int? preferredSelectedListId,
    bool loadSelectedItems = true,
    bool showLoading = true,
  }) async {}

  @override
  Future<void> reload() async {}

  @override
  Future<void> reorderDescending() async {}

  @override
  void reset() => emit(ListsState.initial());

  @override
  Future<void> selectList(int listId) async {
    emit(
      state.copyWith(
        selectedListId: listId,
        items: _itemsByList[listId] ?? const [],
      ),
    );
  }

  @override
  void setCurrentList(int listId) {
    selectList(listId);
  }

  @override
  Future<void> toggleBought(ListItemDto item) async {}

  @override
  Future<void> updateItem(
    ListItemDto item, {
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
  }) async {}

  @override
  Future<void> updateSelectedList({
    required String title,
    required String listType,
  }) async {}
}

void main() {
  Widget buildSubject(_TestListsCubit cubit, {ThemeData? theme}) {
    return BlocProvider<ListsCubit>.value(
      value: cubit,
      child: MaterialApp(
        theme: theme ?? AppTheme.light(),
        home: const ListsScreen(),
      ),
    );
  }

  testWidgets('renders list cards and buyer attribution on bought items', (
    tester,
  ) async {
    final cubit = _TestListsCubit(
      lists: [
        _list(id: 1, title: 'Groceries', pendingItemsCount: 1),
        _list(
          id: 2,
          title: 'Birthday gifts',
          type: 'wishlist',
          pendingItemsCount: 2,
        ),
      ],
      itemsByList: {
        1: [
          _item(
            id: 11,
            listId: 1,
            title: 'Milk',
            isBought: true,
            boughtByDisplayName: 'Nadia',
          ),
        ],
        2: [_item(id: 21, listId: 2, title: 'Candles')],
      },
      selectedListId: 1,
    );

    await tester.pumpWidget(buildSubject(cubit));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsWidgets);
    expect(find.text('Birthday gifts'), findsOneWidget);
    expect(find.textContaining('Marked by Nadia'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('switches detail pane when another list card is tapped', (
    tester,
  ) async {
    final cubit = _TestListsCubit(
      lists: [
        _list(id: 1, title: 'Groceries', pendingItemsCount: 1),
        _list(
          id: 2,
          title: 'Birthday gifts',
          type: 'wishlist',
          pendingItemsCount: 2,
        ),
      ],
      itemsByList: {
        1: [_item(id: 11, listId: 1, title: 'Milk')],
        2: [_item(id: 21, listId: 2, title: 'Candles')],
      },
      selectedListId: 1,
    );

    await tester.pumpWidget(buildSubject(cubit));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Milk'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, 500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Birthday gifts'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Candles'), findsOneWidget);
    expect(find.text('Milk'), findsNothing);

    await cubit.close();
  });

  testWidgets('uses non-white list card gradients in dark theme', (
    tester,
  ) async {
    final cubit = _TestListsCubit(
      lists: [
        _list(id: 1, title: 'Groceries', pendingItemsCount: 1),
      ],
      itemsByList: {
        1: [_item(id: 11, listId: 1, title: 'Milk')],
      },
      selectedListId: 1,
    );

    await tester.pumpWidget(buildSubject(cubit, theme: AppTheme.dark()));
    await tester.pumpAndSettle();

    final card = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final decoration = card.decoration! as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;

    expect(gradient.colors, isNot(contains(Colors.white)));

    await cubit.close();
  });
}

FamilyListDto _list({
  required int id,
  required String title,
  String type = 'shopping',
  int? pendingItemsCount,
}) {
  return FamilyListDto(
    id: id,
    familyId: 1,
    title: title,
    listType: type,
    createdByProfileId: 1,
    pendingItemsCount: pendingItemsCount,
    updatedAt: DateTime.utc(2026, 3, 26, 10 + id),
    version: 1,
  );
}

ListItemDto _item({
  required int id,
  required int listId,
  required String title,
  bool isBought = false,
  String? boughtByDisplayName,
}) {
  return ListItemDto(
    id: id,
    listId: listId,
    title: title,
    qty: 1,
    positionIndex: 1,
    isBought: isBought,
    boughtByProfileId: isBought ? 2 : null,
    boughtByDisplayName: boughtByDisplayName,
    boughtAt: isBought ? DateTime.utc(2026, 3, 26, 12) : null,
    updatedAt: DateTime.utc(2026, 3, 26, 12),
    version: 1,
  );
}
