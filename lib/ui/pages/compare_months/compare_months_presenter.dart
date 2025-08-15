import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CompareMonthsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  List<SaleStatisticViewModel> get firstMonthSales;
  List<SaleStatisticViewModel> get secondMonthSales;

  int get selectedFirstMonth;
  int get selectedFirstYear;
  int get selectedSecondMonth;
  int get selectedSecondYear;

  void changeSelectedFirstMonth(int? month);
  void changeSelectedFirstYear(int? year);
  void changeSelectedSecondMonth(int? month);
  void changeSelectedSecondYear(int? year);

  Future<void> getSales();
}
