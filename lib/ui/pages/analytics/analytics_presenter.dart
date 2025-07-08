import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';

abstract class AnalyticsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> loadAnalytics();
}
