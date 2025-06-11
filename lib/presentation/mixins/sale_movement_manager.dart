import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleMovementManager on GetxController {
  final _sales = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get sales => _sales.value;
  set sales(List<SaleMovementViewModel>? value) => _sales.value = value;

  final _dailySales = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get dailySales => _dailySales.value;
  set dailySales(List<SaleMovementViewModel>? value) =>
      _dailySales.value = value;

  final _monthlySales = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get monthlySales => _monthlySales.value;
  set monthlySales(List<SaleMovementViewModel>? value) =>
      _monthlySales.value = value;

  final _yearlySales = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get yearlySales => _yearlySales.value;
  set yearlySales(List<SaleMovementViewModel>? value) =>
      _yearlySales.value = value;
}
