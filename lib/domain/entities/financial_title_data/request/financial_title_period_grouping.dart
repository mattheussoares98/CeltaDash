/// Wire values defined by Commerce API.
enum FinancialTitlePeriodGrouping {
  day(1),
  month(2),
  year(3);

  final int value;

  const FinancialTitlePeriodGrouping(this.value);
}
