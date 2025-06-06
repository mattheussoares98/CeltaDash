import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleMovementViewModel>? get dailySaleMovements;
  List<SaleMovementViewModel>? get monthlySaleMovements;
  GetSalesParams? get lastGetDailyParams;
  GetSalesParams? get lastGetMonthlyParams;
  EnterpriseViewModel? get lastEnterpriseLoadedData;
  PeriodType get selectedPeriodValue;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
