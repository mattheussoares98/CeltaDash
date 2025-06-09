import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentTypePresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  List<SaleStatisticViewModel>? get saleStatisticsByFinalizations;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  GetSaleStatisticsParams? get lastGetDailyParams;
  PeriodType get selectedPeriodValue;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
