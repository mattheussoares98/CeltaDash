import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

mixin LastGetSaleMovementParamsManager on GetxController {
  GetEcSaleMovementParams? _lastGetSaleMovementParams;
  GetEcSaleMovementParams? get lastGetSaleMovementParams =>
      _lastGetSaleMovementParams;
  set lastParams(GetEcSaleMovementParams? value) =>
      _lastGetSaleMovementParams = value;

  GetEcSaleMovementParams? _lastGetDailyParams;
  GetEcSaleMovementParams? get lastGetDailyParams => _lastGetDailyParams;
  set lastGetDailyParams(GetEcSaleMovementParams? value) =>
      _lastGetDailyParams = value;

  GetEcSaleMovementParams? _lastGetMonthlyParams;
  GetEcSaleMovementParams? get lastGetMonthlyParams => _lastGetMonthlyParams;
  set lastGetMonthlyParams(GetEcSaleMovementParams? value) =>
      _lastGetMonthlyParams = value;

  GetEcSaleMovementParams? _lastGetYearlyParams;
  GetEcSaleMovementParams? get lastGetYearlyParams => _lastGetYearlyParams;
  set lastGetYearlyParams(GetEcSaleMovementParams? value) =>
      _lastGetYearlyParams = value;
}
