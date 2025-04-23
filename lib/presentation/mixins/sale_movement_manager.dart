import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

mixin SaleMovementManager on GetxController {
  final _saleMovement = Rx<SaleMovementViewModel?>(null);
  Stream<SaleMovementViewModel?> get saleMovementStream => _saleMovement.stream;
  set saleMovement(SaleMovementViewModel? value) => _saleMovement.value = value;
}
