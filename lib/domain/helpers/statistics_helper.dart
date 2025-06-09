import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../usecases/usecases.dart';
import 'helpers.dart';

class StatisticsHelper {
  StatisticsHelper._();

  static bool canSearch({
    required bool? forceRefresh,
    required GetSaleStatisticsParams? lastParams,
    required DateTime selectedDate,
    required PeriodType periodType,
  }) {
    if (forceRefresh == true) {
      return true;
    } else if (lastParams == null) {
      return true;
    } else if (periodType == PeriodType.daily) {
      return _canSearchDaily(
        lastParams: lastParams,
        selectedDate: selectedDate,
      );
    } else if (periodType == PeriodType.weekly) {
    } else if (periodType == PeriodType.monthly) {
      return _canSearchMonthly(
        lastParams: lastParams,
        selectedDate: selectedDate,
      );
    } else if (periodType == PeriodType.yearly) {
      return _canSearchYearly(
        lastParams: lastParams,
        selectedDate: selectedDate,
      );
    }

    return false;
  }

  static bool changedTheEnterprise({
    required PeriodType selectedPeriodType,
    required EnterpriseViewModel? selectedEnterprise,
    GetSaleStatisticsParams? lastGetStatisticsParams,
    GetSaleStatisticsParams? lastDailyParams,
    GetSaleStatisticsParams? lastMonthlyParams,
    GetSaleStatisticsParams? lastYearlyParams,
  }) {
    bool changed(GetSaleStatisticsParams? params) {
      return params?.enterpriseIds
              ?.any((e) => e == selectedEnterprise?.id?.toInt()) ==
          false;
    }

    if (lastGetStatisticsParams != null) {
      return changed(lastGetStatisticsParams);
    } else if (selectedPeriodType == PeriodType.daily) {
      return changed(lastDailyParams);
    } else if (selectedPeriodType == PeriodType.monthly) {
      return changed(lastMonthlyParams);
    } else if (selectedPeriodType == PeriodType.yearly) {
      return changed(lastYearlyParams);
    }
    return false;
  }

  static bool _canSearchYearly({
    required GetSaleStatisticsParams? lastParams,
    required DateTime selectedDate,
  }) {
    if (lastParams?.startDate == DateTime(selectedDate.year, 1, 1) &&
        lastParams?.endDate == DateTime(selectedDate.year, 12, 31)) {
      return false;
    } else if (lastParams?.startDate ==
            DateTime(selectedDate.year - 2) &&
        lastParams?.endDate == DateTime(selectedDate.year, 12, 31)) {
      return false;
    } else if (lastParams?.startDate.year == selectedDate.year) {
      return false;
    }

    return true;
  }

  static bool _canSearchMonthly({
    required GetSaleStatisticsParams? lastParams,
    required DateTime selectedDate,
  }) {
    if (lastParams?.startDate == DateTime(selectedDate.year, 1, 1) &&
        lastParams?.endDate == DateTime(selectedDate.year, 12, 31)) {
      return false;
    }

    return lastParams?.startDate.year != selectedDate.year ||
        lastParams?.startDate.month != selectedDate.month ||
        (lastParams?.startDate != null &&
            lastParams?.startDate == lastParams?.endDate);
  }

  static bool _canSearchDaily({
    required GetSaleStatisticsParams? lastParams,
    required DateTime? selectedDate,
  }) =>
      lastParams?.startDate.year != selectedDate?.year ||
      lastParams?.startDate.month != selectedDate?.month ||
      (lastParams?.startDate.day != selectedDate?.day &&
          lastParams?.startDate == lastParams?.endDate);
}
