import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../home/home.dart';

abstract class OperatorsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleMovementViewModel>? get dailySales;
  List<SaleMovementViewModel>? get monthlySales;
  List<SaleMovementViewModel>? get yearlySales;
  GetSalesParams? get lastGetDailyParams;
  GetSalesParams? get lastGetMonthlyParams;
  GetSalesParams? get lastGetYearlyParams;
  PeriodType? get selectedPeriodValue;

  Future<void> getSales(HomePresenter homePresenter, {bool? forceRefresh});
  void emitLoadingAgain();
}
