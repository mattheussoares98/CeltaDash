import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentTypePresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovements;
  List<SaleMovementViewModel>? get saleMovementsByFinalizations;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get lastDateLoadedData;

  Future<void> getSales(HomePresenter homePresenter, {bool? forceRefresh});
  void clear();
}
