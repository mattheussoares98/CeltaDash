import '../usecases/usecases.dart';

enum PeriodGroupingType {
  year,
  month,
  day,
  hour,
}

extension PeriodGroupingTypeExtension on PeriodGroupingType {
  String get name {
    switch (this) {
      case PeriodGroupingType.year:
        return 'Ano';
      case PeriodGroupingType.month:
        return 'Mês';
      case PeriodGroupingType.day:
        return 'Dia';
      case PeriodGroupingType.hour:
        return 'Hora';
    }
  }
}

extension SaleStatisticsPeriodGrouping on GetSaleStatisticsParams {
  bool isPeriodSelected(PeriodGroupingType type) {
    switch (type) {
      case PeriodGroupingType.hour:
        return groupByHour ?? false;
      case PeriodGroupingType.day:
        return groupByDay ?? false;
      case PeriodGroupingType.month:
        return groupByMonth ?? false;
      case PeriodGroupingType.year:
        return groupByYear ?? false;
    }
  }
}
