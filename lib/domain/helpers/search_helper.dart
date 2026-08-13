import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import 'helpers.dart';

abstract class DateRangeParams {
  List<int>? get enterpriseIds;
  DateTime get startDate;
  DateTime get endDate;
}

class SearchHelper {
  SearchHelper._();

  static bool canSearch<T extends DateRangeParams>({
    required bool? forceRefresh,
    required T? lastParams,
    required DateTime selectedDate,
    required PeriodType periodType,
  }) {
    if (forceRefresh == true || lastParams == null) {
      return true;
    }

    switch (periodType) {
      case PeriodType.hourly:
        return _canSearchDaily(lastParams, selectedDate);
      case PeriodType.daily:
        return _canSearchDaily(lastParams, selectedDate);
      case PeriodType.weekly:
        return true;
      case PeriodType.monthly:
        return _canSearchMonthly(lastParams, selectedDate);
      case PeriodType.yearly:
        return _canSearchYearly(lastParams, selectedDate);
      case PeriodType.personalized:
        return true;
    }
  }

  static bool changedTheEnterprise<T extends DateRangeParams>({
    required PeriodType selectedPeriodType,
    required EcEnterpriseViewModel? selectedEnterprise,
    T? lastGetStatisticsParams,
    T? lastHourlyParams,
    T? lastDailyParams,
    T? lastMonthlyParams,
    T? lastYearlyParams,
  }) {
    bool changed(T? params) {
      return params?.enterpriseIds
              ?.any((e) => e == selectedEnterprise?.id?.toInt()) ==
          false;
    }

    if (lastGetStatisticsParams != null) {
      return changed(lastGetStatisticsParams);
    } else if (selectedPeriodType == PeriodType.hourly) {
      return changed(lastHourlyParams);
    } else if (selectedPeriodType == PeriodType.daily) {
      return changed(lastDailyParams);
    } else if (selectedPeriodType == PeriodType.monthly) {
      return changed(lastMonthlyParams);
    } else if (selectedPeriodType == PeriodType.yearly) {
      return changed(lastYearlyParams);
    }
    return false;
  }

  static bool _canSearchYearly<T extends DateRangeParams>(
    T? lastParams,
    DateTime selectedDate,
  ) {
    if (lastParams?.startDate == DateTime(selectedDate.year) &&
        lastParams?.endDate == DateTime(selectedDate.year, 12, 31)) {
      return false;
    } else if (lastParams?.startDate == DateTime(selectedDate.year - 2) &&
        lastParams?.endDate == DateTime(selectedDate.year, 12, 31)) {
      return false;
    } else if (lastParams?.startDate.year == selectedDate.year) {
      return false;
    }

    return true;
  }

  static bool _canSearchMonthly<T extends DateRangeParams>(
    T? lastParams,
    DateTime selectedDate,
  ) {
    if (lastParams?.startDate == DateTime(selectedDate.year) &&
        lastParams?.endDate == DateTime(selectedDate.year, 12, 31)) {
      return false;
    }

    return lastParams?.startDate.year != selectedDate.year ||
        lastParams?.startDate.month != selectedDate.month ||
        (lastParams?.startDate != null &&
            lastParams?.startDate == lastParams?.endDate);
  }

  static bool _canSearchDaily<T extends DateRangeParams>(
    T? lastParams,
    DateTime? selectedDate,
  ) =>
      lastParams?.startDate.year != selectedDate?.year ||
      lastParams?.startDate.month != selectedDate?.month ||
      (lastParams?.startDate.day != selectedDate?.day &&
          lastParams?.startDate == lastParams?.endDate);
}
