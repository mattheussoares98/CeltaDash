import '../../ui/helpers/helpers.dart';

enum NonExclusiveGroupingType {
  enterprise,
  year,
  month,
  day,
  hour,
}

extension NonExclusiveGroupingTypeExtension on NonExclusiveGroupingType {
  String get name {
    switch (this) {
      case NonExclusiveGroupingType.enterprise:
        return R.string.enterprise;
      case NonExclusiveGroupingType.year:
        return R.string.year;
      case NonExclusiveGroupingType.month:
        return R.string.month;
      case NonExclusiveGroupingType.day:
        return R.string.day;
      case NonExclusiveGroupingType.hour:
        return R.string.hour;
    }
  }
}
