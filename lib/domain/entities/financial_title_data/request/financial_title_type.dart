/// Wire values defined by Commerce API.
enum FinancialTitleType {
  receive(1),
  toPay(2);

  final int value;

  const FinancialTitleType(this.value);
}
