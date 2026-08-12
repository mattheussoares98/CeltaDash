/// Wire values defined by Commerce API.
enum FinancialTitleCadasterType {
  customer(1),
  covenant(2),
  supplier(3),
  employee(4),
  enterprise(5),
  administrator(6),
  tax(7),
  carrier(8),
  convene(9),
  generic(10);

  final int value;

  const FinancialTitleCadasterType(this.value);
}
