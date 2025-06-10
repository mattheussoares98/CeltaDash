import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin EcSaleMovementManager on GetxController {
  final _sales = Rx<List<EcSaleMovementViewModel>?>(null);
  List<EcSaleMovementViewModel>? get sales => _sales.value;
  set sales(List<EcSaleMovementViewModel>? value) => _sales.value = value;

  final _dailySales = Rx<List<EcSaleMovementViewModel>?>(null);
  List<EcSaleMovementViewModel>? get dailySales => _dailySales.value;
  set dailySales(List<EcSaleMovementViewModel>? value) =>
      _dailySales.value = value;

  final _monthlySales = Rx<List<EcSaleMovementViewModel>?>(null);
  List<EcSaleMovementViewModel>? get monthlySales => _monthlySales.value;
  set monthlySales(List<EcSaleMovementViewModel>? value) =>
      _monthlySales.value = value;

  final _yearlySales = Rx<List<EcSaleMovementViewModel>?>(null);
  List<EcSaleMovementViewModel>? get yearlySales => _yearlySales.value;
  set yearlySales(List<EcSaleMovementViewModel>? value) =>
      _yearlySales.value = value;
}
