// lib/features/financial_titles/domain/entities/financial_title_situation.dart

enum FinancialTitleSituation {
  open(1, 'Aberto'),
  partiallySettled(2, 'Parcialmente liquidado'),
  completelySettled(3, 'Totalmente liquidado');

  final int value;
  final String label;

  const FinancialTitleSituation(this.value, this.label);

  static FinancialTitleSituation? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is FinancialTitleSituation) return value;
    final intVal = value is int ? value : int.tryParse(value.toString());
    for (final situation in FinancialTitleSituation.values) {
      if (situation.value == intVal) return situation;
    }
    return null;
  }
}
