import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class BsSalesPresenter implements Listenable {
  SaleMovementViewModel? get dailyCanceledSales;
  SaleMovementViewModel? get monthlyCanceledSales;
  SaleMovementViewModel? get notCanceledSales;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<SaleMovementCollectionItemViewModel?> get selectedSaleStream;
  PeriodType get selectedPeriod;
  GetSaleMovementParams? get lastGetDailyParams;
  GetSaleMovementParams? get lastGetMonthlyParams;

  Future<void> getCanceledSales({
    PeriodType? periodType,
    bool? forceRefresh,
  });

  Future<bool> getNotCanceledSales({
    required DateTime date,
    List<String>? documentNumbers,
    int? actualPage,
  });

  void updateSelectedSaleMovement(SaleMovementCollectionItemViewModel sale);
  Future<void> getSelectedSaleDetails();
  Future<void> changeSalesPage(bool isAdvancing);
}
