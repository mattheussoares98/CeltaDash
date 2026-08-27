import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum OperatorsPeriod {
  daily('Dia', PeriodGroupingType.day),
  monthly('Mês', PeriodGroupingType.month),
  yearly('Ano', PeriodGroupingType.year);

  final String label;
  final PeriodGroupingType periodGroupingType;

  const OperatorsPeriod(this.label, this.periodGroupingType);
}
