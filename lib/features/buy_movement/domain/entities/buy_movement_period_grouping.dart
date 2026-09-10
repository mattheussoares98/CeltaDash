enum BuyMovementPeriodGrouping {
  hour(1, 'Horário'),
  day(2, 'Diário'),
  month(3, 'Mensal'),
  year(4, 'Anual');

  final int value;
  final String label;

  const BuyMovementPeriodGrouping(this.value, this.label);

  static BuyMovementPeriodGrouping? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is BuyMovementPeriodGrouping) return value;

    final intValue = value is int ? value : int.tryParse(value.toString());
    for (final grouping in BuyMovementPeriodGrouping.values) {
      if (grouping.value == intValue) return grouping;
    }
    return null;
  }
}
