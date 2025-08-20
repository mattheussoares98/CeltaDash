import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class GoalHistoricPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> loadHistoricSales();
}
