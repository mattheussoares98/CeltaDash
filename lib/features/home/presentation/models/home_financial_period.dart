// lib/features/home/presentation/models/home_financial_period.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';

enum HomeFinancialPeriod {
  daily('Dia', FinancialTitlePeriodGrouping.day),
  monthly('Mês', FinancialTitlePeriodGrouping.month),
  yearly('Ano', FinancialTitlePeriodGrouping.year);

  final String label;
  final FinancialTitlePeriodGrouping periodGrouping;

  const HomeFinancialPeriod(this.label, this.periodGrouping);
}
