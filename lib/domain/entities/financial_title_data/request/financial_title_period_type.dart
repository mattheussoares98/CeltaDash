/// Wire values defined by Commerce API.
enum FinancialTitlePeriodType {
  emission(1, 'Emissão'),
  generation(2, 'Geração'),
  delivery(3, 'Entrega'),
  expiration(4, 'Vencimento'),
  anticipation(5, 'Antecipação'),
  liquidation(6, 'Liquidação'),
  accountTreasuryMovement(7, 'Movimentação contábil');

  final int value;
  final String label;

  const FinancialTitlePeriodType(this.value, this.label);

  static FinancialTitlePeriodType? fromValue(int? value) => value == null
      ? null
      : FinancialTitlePeriodType.values.firstWhere(
          (item) => item.value == value,
        );

  static FinancialTitlePeriodType? fromString(String? value) {
    if (value == null) return null;

    for (var item in FinancialTitlePeriodType.values) {
      if (item.name.toString().toLowerCase() == value.toLowerCase()) {
        return item;
      }
    }
    return null;
  }
}
