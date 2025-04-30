import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ResumePresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovements;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  int? get lastMonthLoadedData;

  void goToProfitabillityPage();
  void goToCompareDays();
  void goToSectionsPage();
  void goToPaymentsTypePage();
  void goToSetGoalPage();
  void goToGoalHistoryPage();
  void goToGroupSummaryPage();

  Future<void> getSales(HomePresenter homePresenter);
}
