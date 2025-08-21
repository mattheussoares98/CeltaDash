import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class HistoricGoalPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  List<SaleStatisticViewModel>? get saleStatistics;

  Future<void> loadHistoricSales(int year);
}
