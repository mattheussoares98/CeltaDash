import '../../ui/helpers/helpers.dart';
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
        return R.string.year;
      case PeriodGroupingType.month:
        return R.string.month;
      case PeriodGroupingType.day:
        return R.string.day;
      case PeriodGroupingType.hour:
        return R.string.hour;
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
