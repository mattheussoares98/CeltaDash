import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class DepartmentsPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  PeriodType get selectedPeriodValue;
  GetEcSaleStatisticsParams? get lastGetStatisticsParams;

  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  });
}
