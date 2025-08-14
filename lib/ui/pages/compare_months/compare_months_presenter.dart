import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CompareMonthsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  List<SaleStatisticViewModel>? get previousMonth;
  List<SaleStatisticViewModel>? get selectedMonth;
  List<SaleStatisticViewModel>? get previousYear;

  Future<void> getSales({
    required DateTime now,
    DateTime selectedDate,
    bool? forceRefresh,
  });
}
