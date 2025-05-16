import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  //TODO create FirebaseEnterpriseViewModel

  Future<void> getCustomers();
}
