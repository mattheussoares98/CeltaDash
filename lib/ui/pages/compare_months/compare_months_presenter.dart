import 'package:flutter/widgets.dart';

import '../pages.dart';

abstract class CompareMonthsPresenter implements Listenable {
  List<SaleStatisticViewModel>? get sameMonthLastYear;
  List<SaleStatisticViewModel>? get sameMonthCurrentYear;
  List<SaleStatisticViewModel>? get previousMonthCurrentYear;

  Future<void> getSales({
    required DateTime selectedDate,
    bool? forceRefresh,
  });
}
