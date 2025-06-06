import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get dailySales;
  List<SaleMovementViewModel>? get monthlySales;
  List<SaleMovementViewModel>? get yearlySales;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  GetSalesParams? get lastGetDailyParams;
  GetSalesParams? get lastGetMonthlyParams;
  GetSalesParams? get lastGetYearlyParams;
  PeriodType get selectedPeriodValue;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
