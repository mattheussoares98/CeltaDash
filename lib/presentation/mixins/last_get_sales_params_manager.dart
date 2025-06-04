import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

mixin LastGetSalesParamsManager on GetxController {
  GetSalesParams? _lastGetSalesParams;
  GetSalesParams? get lastGetSalesParams => _lastGetSalesParams;
  set lastParams(GetSalesParams? value) => _lastGetSalesParams = value;
}
