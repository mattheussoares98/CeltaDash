import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class BsSalesPresenter implements Listenable {
  List<SaleMovementCollectionItemViewModel>? get dailyCanceledSales;
  List<SaleMovementCollectionItemViewModel>? get monthlyCanceledSales;
  List<SaleMovementCollectionItemViewModel>? get notCanceledSales;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<SaleMovementCollectionItemViewModel?> get selectedSaleStream;
  PeriodType get selectedPeriod;
  GetSaleMovementParams? get lastGetDailyParams;
  GetSaleMovementParams? get lastGetMonthlyParams;

  Future<void> getCanceledSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });

  Future<void> getNotCanceledSales();

  void updateSelectedSaleMovement(SaleMovementCollectionItemViewModel sale);
  Future<void> getSelectedSaleDetails();
}
