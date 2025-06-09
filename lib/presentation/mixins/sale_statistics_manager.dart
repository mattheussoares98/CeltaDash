import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleStatisticsManager on GetxController {
  final _saleStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  List<SaleStatisticViewModel>? get saleStatistics => _saleStatistics.value;
  set saleStatistics(List<SaleStatisticViewModel>? value) =>
      _saleStatistics.value = value;

  final _dailyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  List<SaleStatisticViewModel>? get dailyStatistics =>
      _dailyStatistics.value;
  set dailyStatistics(List<SaleStatisticViewModel>? value) =>
      _dailyStatistics.value = value;

  final _monthlyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  List<SaleStatisticViewModel>? get monthlyStatistics =>
      _monthlyStatistics.value;
  set monthlyStatistics(List<SaleStatisticViewModel>? value) =>
      _monthlyStatistics.value = value;

  final _yearlyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  List<SaleStatisticViewModel>? get yearlyStatistics =>
      _yearlyStatistics.value;
  set yearlyStatistics(List<SaleStatisticViewModel>? value) =>
      _yearlyStatistics.value = value;
}
