import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SalesPresenter implements Listenable {
  List<SaleStatisticViewModel>? get dailyStatistics;
  List<SaleStatisticViewModel>? get monthlyStatistics;
  List<SaleStatisticViewModel>? get yearlyStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  GetSaleStatisticsParams? get lastGetDailyParams;
  GetSaleStatisticsParams? get lastGetMonthlyParams;
  GetSaleStatisticsParams? get lastGetYearlyParams;
  PeriodType get selectedPeriod;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
