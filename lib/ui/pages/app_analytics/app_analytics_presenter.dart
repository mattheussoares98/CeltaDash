import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import 'view_models/view_models.dart';

abstract class AppAnalyticsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<MonthlyAnalyticsViewModel>? get analytics;

  DateTime? get selectedPeriod;

  Future<void> loadAnalytics();
  void changeSelectedPeriod(DateTime? period);
}
