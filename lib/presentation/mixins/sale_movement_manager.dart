import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleMovementManager on GetxController {
  final _saleMovements = Rx<List<SaleMovementViewModel>?>(null);
  Stream<List<SaleMovementViewModel>?> get saleMovementStream =>
      _saleMovements.stream;
  set saleMovements(List<SaleMovementViewModel>? value) =>
      _saleMovements.value = value;
}
