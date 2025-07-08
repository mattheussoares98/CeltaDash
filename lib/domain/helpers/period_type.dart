import '../../ui/helpers/helpers.dart';

enum PeriodType {
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
}

extension PeriodTypeExtension on PeriodType {
  String get description {
    switch (this) {
      case PeriodType.hourly:
        return R.string.hour;
      case PeriodType.daily:
        return R.string.day;
      case PeriodType.weekly:
        return R.string.week;
      case PeriodType.monthly:
        return R.string.month;
      case PeriodType.yearly:
        return R.string.year;
    }
  }
}
