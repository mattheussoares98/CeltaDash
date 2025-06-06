import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';

mixin PeriodTypeManager on GetxController {
  PeriodType _selectedPeriodType = PeriodType.daily;
  PeriodType get selectedPeriodValue => _selectedPeriodType;
  set selectedPeriod(PeriodType value) => _selectedPeriodType = value;
}
