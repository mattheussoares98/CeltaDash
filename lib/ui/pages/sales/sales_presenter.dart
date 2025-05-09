import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovements;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> getSales({
    required HomePresenter homePresenter,
    required bool searchByHour,
    required bool searchByDay,
    required bool searchByMonth,
    required bool searchByYear,
  });
}
