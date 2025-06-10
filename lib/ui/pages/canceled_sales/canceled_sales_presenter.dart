import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CanceledSalesPresenter implements Listenable {
  List<EcSaleMovementViewModel>? get dailySales;
  List<EcSaleMovementViewModel>? get monthlySales;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  PeriodType get selectedPeriod;
  GetEcSaleMovementParams? get lastGetDailyParams;
  GetEcSaleMovementParams? get lastGetMonthlyParams;
  EcSaleMovementViewModel? get selectedSaleMovement;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
