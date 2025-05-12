import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleMovementViewModel>? get saleMovements;
  Future<void> loadProducts(HomePresenter homePresenter);
}
