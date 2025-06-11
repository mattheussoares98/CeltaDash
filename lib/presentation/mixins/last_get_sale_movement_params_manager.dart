import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

mixin LastGetSaleMovementParamsManager on GetxController {
  GetSaleMovementParams? _lastGetSaleMovementParams;
  GetSaleMovementParams? get lastGetSaleMovementParams =>
      _lastGetSaleMovementParams;
  set lastParams(GetSaleMovementParams? value) =>
      _lastGetSaleMovementParams = value;

  GetSaleMovementParams? _lastGetDailyParams;
  GetSaleMovementParams? get lastGetDailyParams => _lastGetDailyParams;
  set lastGetDailyParams(GetSaleMovementParams? value) =>
      _lastGetDailyParams = value;

  GetSaleMovementParams? _lastGetMonthlyParams;
  GetSaleMovementParams? get lastGetMonthlyParams => _lastGetMonthlyParams;
  set lastGetMonthlyParams(GetSaleMovementParams? value) =>
      _lastGetMonthlyParams = value;

  GetSaleMovementParams? _lastGetYearlyParams;
  GetSaleMovementParams? get lastGetYearlyParams => _lastGetYearlyParams;
  set lastGetYearlyParams(GetSaleMovementParams? value) =>
      _lastGetYearlyParams = value;
}
