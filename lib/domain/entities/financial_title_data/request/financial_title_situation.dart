/// Wire values defined by Commerce API.
enum FinancialTitleSituation {
  open(1),
  partiallySettled(2),
  completelySettled(3);

  final int value;

  const FinancialTitleSituation(this.value);

  static FinancialTitleSituation? fromValue(int? value) => value == null
      ? null
      : FinancialTitleSituation.values
          .firstWhere((item) => item.value == value);

  static FinancialTitleSituation? fromString(String? value) {
    if (value == null) return null;

    for (var item in FinancialTitleSituation.values) {
      if (item.name.toString().toLowerCase() == value.toLowerCase()) {
        return item;
      }
    }
    return null;
  }
}
