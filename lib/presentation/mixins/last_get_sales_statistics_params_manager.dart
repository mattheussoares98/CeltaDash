import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

mixin LastGetSalesStatisticsParamsManager on GetxController {
  GetSaleStatisticsParams? _lastGetStatisticsParams;
  GetSaleStatisticsParams? get lastGetStatisticsParams =>
      _lastGetStatisticsParams;
  set lastParams(GetSaleStatisticsParams? value) =>
      _lastGetStatisticsParams = value;

  GetSaleStatisticsParams? _lastGetHourlyParams;
  GetSaleStatisticsParams? get lastGetHourlyParams => _lastGetHourlyParams;
  set lastGetHourlyParams(GetSaleStatisticsParams? value) =>
      _lastGetHourlyParams = value;

  GetSaleStatisticsParams? _lastGetDailyParams;
  GetSaleStatisticsParams? get lastGetDailyParams => _lastGetDailyParams;
  set lastGetDailyParams(GetSaleStatisticsParams? value) =>
      _lastGetDailyParams = value;

  GetSaleStatisticsParams? _lastGetMonthlyParams;
  GetSaleStatisticsParams? get lastGetMonthlyParams => _lastGetMonthlyParams;
  set lastGetMonthlyParams(GetSaleStatisticsParams? value) =>
      _lastGetMonthlyParams = value;

  GetSaleStatisticsParams? _lastGetYearlyParams;
  GetSaleStatisticsParams? get lastGetYearlyParams => _lastGetYearlyParams;
  set lastGetYearlyParams(GetSaleStatisticsParams? value) =>
      _lastGetYearlyParams = value;

  GetSaleStatisticsParams? _lastGetComparisonParams;
  GetSaleStatisticsParams? get lastGetComparisonParams =>
      _lastGetComparisonParams;
  set lastGetComparisonParams(GetSaleStatisticsParams? value) =>
      _lastGetComparisonParams = value;
}
