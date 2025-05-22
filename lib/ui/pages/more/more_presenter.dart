import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';

abstract class MorePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> doLogout();
}
