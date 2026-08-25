// lib/features/financial_titles/domain/entities/financial_title_period_type.dart

enum FinancialTitlePeriodType {
  emission(1, 'Emissão'),
  generation(2, 'Geração'),
  delivery(3, 'Entrega'),
  expiration(4, 'Vencimento'),
  anticipation(5, 'Antecipação'),
  liquidation(6, 'Liquidação'),
  accountTreasuryMovement(7, 'Movimento de Conta');

  final int value;
  final String label;

  const FinancialTitlePeriodType(this.value, this.label);

  static FinancialTitlePeriodType? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is FinancialTitlePeriodType) return value;
    final intVal = value is int ? value : int.tryParse(value.toString());
    for (final type in FinancialTitlePeriodType.values) {
      if (type.value == intVal) return type;
    }
    return null;
  }
}
