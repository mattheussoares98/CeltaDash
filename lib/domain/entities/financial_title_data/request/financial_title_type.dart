/// Wire values defined by Commerce API.
enum FinancialTitleType {
  receive(1),
  toPay(2);

  final int value;

  const FinancialTitleType(this.value);

  static FinancialTitleType? fromValue(int? value) => value == null
      ? null
      : FinancialTitleType.values.firstWhere((item) => item.value == value);
}
