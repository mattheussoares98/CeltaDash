import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleStatisticViewModel>? get dailyStatistics;
  List<SaleStatisticViewModel>? get monthlyStatistics;
  GetEcSaleStatisticsParams? get lastGetDailyParams;
  GetEcSaleStatisticsParams? get lastGetMonthlyParams;
  PeriodType get selectedPeriodValue;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
