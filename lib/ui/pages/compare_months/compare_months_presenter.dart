import 'package:flutter/widgets.dart';

import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CompareMonthsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Map<CompareMonthsPeriod, List<SaleStatisticViewModel>> get mergedSales;
  //the key is the month and year like 082025

  GetSaleStatisticsParams? get lastParams;

  Future<void> getSales({
    required DateTime now,
    DateTime selectedDate,
    bool? forceRefresh,
  });
}
