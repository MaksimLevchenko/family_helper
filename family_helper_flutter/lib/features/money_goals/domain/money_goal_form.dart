class MoneyGoalForm {
  const MoneyGoalForm({
    required this.title,
    required this.targetAmountCents,
    this.currency = 'RUB',
  });

  final String title;
  final int targetAmountCents;
  final String currency;
}
