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
        return R.string.hourly;
      case PeriodType.daily:
        return R.string.daily;
      case PeriodType.weekly:
        return R.string.weekly;
      case PeriodType.monthly:
        return R.string.monthly;
      case PeriodType.yearly:
        return R.string.yearly;
    }
  }
}
