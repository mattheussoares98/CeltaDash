/// Wire values defined by Commerce API.
enum FinancialTitleSituation {
  open(1),
  partiallySettled(2),
  completelySettled(3);

  final int value;

  const FinancialTitleSituation(this.value);
}
