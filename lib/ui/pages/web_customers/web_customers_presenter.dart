import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';

abstract class WebCustomersPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<UIError> get mainErrorStream;

  Future<void> getCustomers();
}
