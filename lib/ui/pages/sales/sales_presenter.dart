import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovementsByDay;
  List<SaleMovementViewModel>? get saleMovementsByMonth;
  List<SaleMovementViewModel>? get saleMovementsByYear;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  GetSalesParams? get lastGetDailyParams;
  GetSalesParams? get lastGetMonthlyParams;
  GetSalesParams? get lastGetYearlyParams;
  EnterpriseViewModel? get lastDailyEnterprise;
  EnterpriseViewModel? get lastMonthlyEnterprise;
  EnterpriseViewModel? get lastYearlyEnterprise;
  PeriodType get selectedPeriodValue;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
