import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleMovementManager on GetxController {
  final _saleMovements = Rx<List<SaleMovementViewModel>?>(null);
  List<SaleMovementViewModel>? get saleMovements => _saleMovements.value;
  set saleMovements(List<SaleMovementViewModel>? value) =>
      _saleMovements.value = value;
}
