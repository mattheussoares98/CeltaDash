import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentTypePresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovements;
  List<SaleMovementViewModel>? get saleMovementsByFinalizations;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get lastDateLoadedData;
  PeriodType get selectedPeriodType;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
  void emitLoadingAgain();
}
