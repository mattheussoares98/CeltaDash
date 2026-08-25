// lib/features/financial_titles/domain/entities/financial_title_cadaster_type.dart

enum FinancialTitleCadasterType {
  customer(1, 'Cliente'),
  covenant(2, 'Convênio'),
  supplier(3, 'Fornecedor'),
  employee(4, 'Funcionário'),
  enterprise(5, 'Empresa'),
  administrator(6, 'Administradora'),
  tax(7, 'Imposto'),
  carrier(8, 'Transportadora'),
  convene(9, 'Convene'),
  generic(10, 'Genérico');

  final int value;
  final String label;

  const FinancialTitleCadasterType(this.value, this.label);

  static FinancialTitleCadasterType? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is FinancialTitleCadasterType) return value;
    final intVal = value is int ? value : int.tryParse(value.toString());
    for (final cadaster in FinancialTitleCadasterType.values) {
      if (cadaster.value == intVal) return cadaster;
    }
    return null;
  }
}
