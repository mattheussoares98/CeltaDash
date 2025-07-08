import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import 'view_models/view_models.dart';

abstract class AnalyticsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<MonthlyAnalyticsViewModel>? get analytics;

  Future<void> loadAnalytics();
}
