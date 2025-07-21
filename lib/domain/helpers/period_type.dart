import '../../ui/helpers/helpers.dart';

enum PeriodType {
  hourly,
  daily,
  weekly,
  monthly,
  personalized,
  yearly,
}

extension PeriodTypeDescriptionExtension on PeriodType {
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
      case PeriodType.personalized:
        return R.string.personalized;
      case PeriodType.yearly:
        return R.string.yearly;
    }
  }
}

extension PeriodTypeNameExtension on PeriodType {
  String get name {
    switch (this) {
      case PeriodType.hourly:
        return R.string.hour;
      case PeriodType.daily:
        return R.string.day;
      case PeriodType.weekly:
        return R.string.week;
      case PeriodType.monthly:
        return R.string.month;
      case PeriodType.personalized:
        return R.string.personalized;
      case PeriodType.yearly:
        return R.string.year;
    }
  }
}
