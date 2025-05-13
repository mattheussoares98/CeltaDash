import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleMovementViewModel>? get saleMovements;
  DateTime? get lastDateLoadedData;
  EnterpriseViewModel? get lastEnterpriseLoadedData;

  Future<void> loadProducts(HomePresenter homePresenter, {bool? forceRefresh});
}
