class ListItemForm {
  const ListItemForm({
    required this.title,
    this.qty = 1,
    this.unit,
    this.priceCents,
  });

  final String title;
  final double qty;
  final String? unit;
  final int? priceCents;
}
