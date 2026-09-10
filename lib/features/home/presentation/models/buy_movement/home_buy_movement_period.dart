import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';

enum HomeBuyMovementPeriod {
  hourly('Hora', BuyMovementPeriodGrouping.hour),
  daily('Dia', BuyMovementPeriodGrouping.day),
  monthly('Mês', BuyMovementPeriodGrouping.month),
  yearly('Ano', BuyMovementPeriodGrouping.year);

  final String label;
  final BuyMovementPeriodGrouping periodGrouping;

  const HomeBuyMovementPeriod(this.label, this.periodGrouping);
}
