import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';

abstract class MorePresenter implements Listenable {
  //TODO delete this presenter
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> doLogout();
  void goToOperatorsProductivityPage();
}
