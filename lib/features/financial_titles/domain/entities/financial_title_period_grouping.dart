// lib/features/financial_titles/domain/entities/financial_title_period_grouping.dart

enum FinancialTitlePeriodGrouping {
  day(1, 'Diário'),
  month(2, 'Mensal'),
  year(3, 'Anual');

  final int value;
  final String label;

  const FinancialTitlePeriodGrouping(this.value, this.label);

  static FinancialTitlePeriodGrouping? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is FinancialTitlePeriodGrouping) return value;
    final intVal = value is int ? value : int.tryParse(value.toString());
    for (final grouping in FinancialTitlePeriodGrouping.values) {
      if (grouping.value == intVal) return grouping;
    }
    return null;
  }
}
