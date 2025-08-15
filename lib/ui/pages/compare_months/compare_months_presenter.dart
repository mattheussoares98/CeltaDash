import 'package:flutter/widgets.dart';

import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CompareMonthsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  List<SaleStatisticViewModel> get firstMonthSales;
  List<SaleStatisticViewModel> get secondMonthSales;

  GetSaleStatisticsParams? get firstMonthParams;
  GetSaleStatisticsParams? get secondMonthParams;

  int get firstSelectedMonth;
  int get firstSelectedYear;
  int get secondSelectedMonth;
  int get secondSelectedYear;

  void changeFirstSelectedMonth(int month);
  void changeFirstSelectedYear(int year);
  void changeSecondSelectedMonth(int month);
  void changeSecondSelectedYear(int year);

  Future<void> getSales(bool forceRefresh);
}
