import '../../ui/helpers/helpers.dart';

enum PeriodGroupingType {
  enterprise,
  year,
  month,
  day,
  hour,
}

extension PeriodGroupingTypeExtension on PeriodGroupingType {
  String get name {
    switch (this) {
      case PeriodGroupingType.enterprise:
        return R.string.enterprise;
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
