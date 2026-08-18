// lib/features/home/presentation/models/sales_period.dart
import 'package:celta_dash/domain/helpers/helpers.dart';

enum SalesPeriod {
  hourly('Hora', PeriodGroupingType.hour),
  daily('Dia', PeriodGroupingType.day),
  monthly('Mês', PeriodGroupingType.month),
  yearly('Ano', PeriodGroupingType.year);

  final String label;
  final PeriodGroupingType periodGroupingType;

  const SalesPeriod(this.label, this.periodGroupingType);
}
