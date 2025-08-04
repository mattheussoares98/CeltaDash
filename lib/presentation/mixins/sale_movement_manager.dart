import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleMovementManager on GetxController {
  final _sales = Rx<List<SaleMovementCollectionItemViewModel>?>(null);
  List<SaleMovementCollectionItemViewModel>? get sales => _sales.value;
  set sales(List<SaleMovementCollectionItemViewModel>? value) =>
      _sales.value = value;

  final _dailySales = Rx<List<SaleMovementCollectionItemViewModel>?>(null);
  List<SaleMovementCollectionItemViewModel>? get dailySales =>
      _dailySales.value;
  set dailySales(List<SaleMovementCollectionItemViewModel>? value) =>
      _dailySales.value = value;

  final _monthlySales = Rx<List<SaleMovementCollectionItemViewModel>?>(null);
  List<SaleMovementCollectionItemViewModel>? get monthlySales =>
      _monthlySales.value;
  set monthlySales(List<SaleMovementCollectionItemViewModel>? value) =>
      _monthlySales.value = value;

  final _yearlySales = Rx<List<SaleMovementCollectionItemViewModel>?>(null);
  List<SaleMovementCollectionItemViewModel>? get yearlySales =>
      _yearlySales.value;
  set yearlySales(List<SaleMovementCollectionItemViewModel>? value) =>
      _yearlySales.value = value;
}
