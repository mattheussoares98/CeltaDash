import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

mixin LastGetSalesParamsManager on GetxController {
  GetSalesParams? _lastGetSalesParams;
  GetSalesParams? get lastGetSalesParams => _lastGetSalesParams;
  set lastParams(GetSalesParams? value) => _lastGetSalesParams = value;

  GetSalesParams? _lastGetDailyParams;
  GetSalesParams? get lastGetDailyParams => _lastGetDailyParams;
  set lastDaily(GetSalesParams? value) => _lastGetDailyParams = value;
//TODO change the set name equal the value
  GetSalesParams? _lastGetMonthlyParams;
  GetSalesParams? get lastGetMonthlyParams => _lastGetMonthlyParams;
  set lastMonthly(GetSalesParams? value) => _lastGetMonthlyParams = value;

  GetSalesParams? _lastGetYearlyParams;
  GetSalesParams? get lastGetYearlyParams => _lastGetYearlyParams;
  set lastYearly(GetSalesParams? value) => _lastGetYearlyParams = value;
}
