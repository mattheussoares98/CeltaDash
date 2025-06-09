import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CanceledSalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovements;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> getSales(HomePresenter homePresenter);
}
