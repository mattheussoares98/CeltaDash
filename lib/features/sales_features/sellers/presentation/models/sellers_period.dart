// lib/features/sellers/presentation/models/sellers_period.dart
import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum SellersPeriod {
  daily('Dia', PeriodGroupingType.day),
  monthly('Mês', PeriodGroupingType.month),
  yearly('Ano', PeriodGroupingType.year);

  final String label;
  final PeriodGroupingType periodGroupingType;

  const SellersPeriod(this.label, this.periodGroupingType);
}
