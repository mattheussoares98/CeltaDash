import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ResumePresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  List<SaleStatisticViewModel>? get compareDaysStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  PeriodType get selectedPeriod;
  GetSaleStatisticsParams? get lastGetStatisticsParams;

  void goToSetGoalPage();
  void goToGoalHistoryPage();
  void goToGroupSummaryPage();

  Future<void> getSales(
    HomePresenter homePresenter, {
    required DateTime now,
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
