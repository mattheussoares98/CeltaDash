// lib/features/financial_titles/domain/entities/financial_title_type.dart

enum FinancialTitleType {
  receive(1, 'Receber'),
  toPay(2, 'Pagar');

  final int value;
  final String label;

  const FinancialTitleType(this.value, this.label);

  static FinancialTitleType? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is FinancialTitleType) return value;
    final intVal = value is int ? value : int.tryParse(value.toString());
    for (final type in FinancialTitleType.values) {
      if (type.value == intVal) return type;
    }
    return null;
  }
}
