import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleMovementManager on GetxController {
  final _saleMovements = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get saleMovements => _saleMovements.value;
  set saleMovements(List<SaleMovementViewModel>? value) =>
      _saleMovements.value = value;

  final _dailySaleMovements = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get dailySales =>
      _dailySaleMovements.value;
  set dailySales(List<SaleMovementViewModel>? value) =>
      _dailySaleMovements.value = value;

  final _monthlySaleMovements = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get monthlySales =>
      _monthlySaleMovements.value;
  set monthlySales(List<SaleMovementViewModel>? value) =>
      _monthlySaleMovements.value = value;

  final _yearlySaleMovements = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get yearlySales =>
      _yearlySaleMovements.value;
  set yearlySales(List<SaleMovementViewModel>? value) =>
      _yearlySaleMovements.value = value;
}
