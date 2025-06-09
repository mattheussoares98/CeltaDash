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
  GetEcSaleStatisticsParams? get lastGetDailyParams;
  GetEcSaleStatisticsParams? get lastGetMonthlyParams;
  GetEcSaleStatisticsParams? get lastGetYearlyParams;
  PeriodType get selectedPeriodValue;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
