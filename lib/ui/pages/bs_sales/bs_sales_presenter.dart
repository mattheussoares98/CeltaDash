import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class BsSalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get dailySales;
  List<SaleMovementViewModel>? get monthlySales;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<SaleMovementViewModel?> get selectedSaleStream;
  PeriodType get selectedPeriod;
  GetSaleMovementParams? get lastGetDailyParams;
  GetSaleMovementParams? get lastGetMonthlyParams;

  Future<void> getCanceledSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });

  Future<void> getNotCanceledSales();

  void updateSelectedSaleMovement(SaleMovementViewModel sale);
  Future<void> getSelectedSaleDetails();
}
