import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../home/home.dart';

abstract class OperatorsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleStatisticViewModel>? get dailyStatistics;
  List<SaleStatisticViewModel>? get monthlyStatistics;
  List<SaleStatisticViewModel>? get yearlyStatistics;
  GetSaleStatisticsParams? get lastGetDailyParams;
  GetSaleStatisticsParams? get lastGetMonthlyParams;
  GetSaleStatisticsParams? get lastGetYearlyParams;
  PeriodType? get selectedPeriod;

  Future<void> getSales({
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
