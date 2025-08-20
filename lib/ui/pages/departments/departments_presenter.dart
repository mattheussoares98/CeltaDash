import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class DepartmentsPresenter implements Listenable {
  List<SaleStatisticViewModel>? get dailyStatistics;
  List<SaleStatisticViewModel>? get monthlyStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  PeriodType get selectedPeriod;
  GetSaleStatisticsParams? get lastGetDailyParams;
  GetSaleStatisticsParams? get lastGetMonthlyParams;

  Future<void> getSales({
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
