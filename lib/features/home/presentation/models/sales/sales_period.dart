// lib/features/home/presentation/models/sales_period.dart
import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum HomeSalesPeriod {
  hourly('Hora', PeriodGroupingType.hour),
  daily('Dia', PeriodGroupingType.day),
  monthly('Mês', PeriodGroupingType.month),
  yearly('Ano', PeriodGroupingType.year);

  final String label;
  final PeriodGroupingType periodGroupingType;

  const HomeSalesPeriod(this.label, this.periodGroupingType);
}
