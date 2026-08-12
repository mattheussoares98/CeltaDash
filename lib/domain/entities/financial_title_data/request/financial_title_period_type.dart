/// Wire values defined by Commerce API.
enum FinancialTitlePeriodType {
  emission(1),
  generation(2),
  delivery(3),
  expiration(4),
  anticipation(5),
  liquidation(6),
  accountTreasuryMovement(7);

  final int value;

  const FinancialTitlePeriodType(this.value);

  static FinancialTitlePeriodType? fromValue(int? value) => value == null
      ? null
      : FinancialTitlePeriodType.values.firstWhere(
          (item) => item.value == value,
        );
}
