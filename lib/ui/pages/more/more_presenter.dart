import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class MorePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  void goToConfigurationsPage();
  void goToComparisonsPage();
  void logout();
}
