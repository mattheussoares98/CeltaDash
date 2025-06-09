import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

mixin LastGetSalesStatisticsParamsManager on GetxController {
  GetEcSaleStatisticsParams? _lastGetStatisticsParams;
  GetEcSaleStatisticsParams? get lastGetStatisticsParams => _lastGetStatisticsParams;
  set lastParams(GetEcSaleStatisticsParams? value) => _lastGetStatisticsParams = value;

  GetEcSaleStatisticsParams? _lastGetDailyParams;
  GetEcSaleStatisticsParams? get lastGetDailyParams => _lastGetDailyParams;
  set lastGetDailyParams(GetEcSaleStatisticsParams? value) => _lastGetDailyParams = value;

  GetEcSaleStatisticsParams? _lastGetMonthlyParams;
  GetEcSaleStatisticsParams? get lastGetMonthlyParams => _lastGetMonthlyParams;
  set lastGetMonthlyParams(GetEcSaleStatisticsParams? value) =>
      _lastGetMonthlyParams = value;

  GetEcSaleStatisticsParams? _lastGetYearlyParams;
  GetEcSaleStatisticsParams? get lastGetYearlyParams => _lastGetYearlyParams;
  set lastGetYearlyParams(GetEcSaleStatisticsParams? value) =>
      _lastGetYearlyParams = value;
}
