import '../usecases/usecases.dart';
import 'helpers.dart';

class CanSearchAgain {
  CanSearchAgain._();

  static bool get({
    required bool? forceRefresh,
    required GetSalesParams? lastGetSalesParams,
    required DateTime selectedDate,
    required PeriodType periodType,
  }) {
    //TODO create tests
    if (forceRefresh == true) {
      return true;
    } else if (lastGetSalesParams == null) {
      return true;
    } else if (periodType == PeriodType.daily) {
      return _canSearchDaily(
        lastGetSalesParams: lastGetSalesParams,
        selectedDate: selectedDate,
      );
    } else if (periodType == PeriodType.weekly) {
    } else if (periodType == PeriodType.monthly) {
      return _canSearchMonthly(
        lastGetSalesParams: lastGetSalesParams,
        selectedDate: selectedDate,
      );
    } else if (periodType == PeriodType.yearly) {}

    return false;
  }

  static bool _canSearchMonthly({
    required GetSalesParams? lastGetSalesParams,
    required DateTime? selectedDate,
  }) =>
      lastGetSalesParams?.startDate.year != selectedDate?.year ||
      lastGetSalesParams?.startDate.month != selectedDate?.month ||
      (lastGetSalesParams?.startDate != null &&
          lastGetSalesParams?.startDate == lastGetSalesParams?.endDate);
  static bool _canSearchDaily({
    required GetSalesParams? lastGetSalesParams,
    required DateTime? selectedDate,
  }) =>
      lastGetSalesParams?.startDate.year != selectedDate?.year ||
      lastGetSalesParams?.startDate.month != selectedDate?.month ||
      (lastGetSalesParams?.startDate != null &&
          lastGetSalesParams?.startDate == lastGetSalesParams?.endDate);
}
