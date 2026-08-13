/// Wire values defined by Commerce API.
enum FinancialTitlePeriodGrouping {
  day(1),
  month(2),
  year(3);

  final int value;

  const FinancialTitlePeriodGrouping(this.value);

  static FinancialTitlePeriodGrouping? fromValue(int? value) => value == null
      ? null
      : FinancialTitlePeriodGrouping.values.firstWhere(
          (item) => item.value == value,
        );

  static FinancialTitlePeriodGrouping? fromString(String? value) {
    if (value == null) return null;

    for (var item in FinancialTitlePeriodGrouping.values) {
      if (item.name.toString().toLowerCase() == value.toLowerCase()) {
        return item;
      }
    }
    return null;
  }
}
