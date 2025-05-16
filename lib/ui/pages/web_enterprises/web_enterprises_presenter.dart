import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import 'firebase_enterprise_view_model.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<FirebaseEnterpriseViewModel>?> get enterprisesStream;

  Future<void> getEnterprises();
  void goToEnterpriseDetails();
}
