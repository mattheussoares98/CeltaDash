import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ResumePresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  PeriodType get selectedPeriod;
  GetEcSaleStatisticsParams? get lastGetStatisticsParams;

  void goToProfitabillityPage();
  void goToCompareDays();
  void goToDepartmentsPage();
  void goToPaymentsTypePage();
  void goToSetGoalPage();
  void goToGoalHistoryPage();
  void goToGroupSummaryPage();

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
