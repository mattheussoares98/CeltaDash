import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class BsSalesPresenter implements Listenable {
  SaleMovementViewModel? get dailySales;
  SaleMovementViewModel? get monthlySales;
  SaleMovementViewModel? get notSales;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<SaleMovementCollectionItemViewModel?> get selectedSaleStream;
  PeriodType get selectedPeriod;
  GetSaleMovementParams? get lastGetDailyParams;
  GetSaleMovementParams? get lastGetMonthlyParams;

  Future<void> getSales({
    PeriodType? periodType,
    bool? forceRefresh,
  });

  Future<bool> getNotSales({
    required DateTime date,
    List<String>? documentNumbers,
    int? actualPage,
  });

  void updateSelectedSaleMovement(SaleMovementCollectionItemViewModel sale);
  Future<void> getSelectedSaleDetails();
  Future<void> changeSalesPage(bool isAdvancing);
}
