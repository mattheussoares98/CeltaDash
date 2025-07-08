import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<FirebaseEnterpriseViewModel>?> get enterprisesStream;
  FirebaseEnterpriseViewModel? get selectedEnterprise;

  Future<void> getEnterprises();
  void goToEnterpriseDetails(FirebaseEnterpriseViewModel enterprise);
  Future<void> changeEnterpriseUrl(String newUrl);
  Future<void> addNewEnterprise({
    required String baseUrl,
    required String enterpriseName,
    required String bsUserName,
    required String bsPassword,
    required void Function() doOnSucceeds,
  });
  void goToLoginPage();
  Future<bool> changeEnterpriseIsEnabled(int subEnterpriseIndex);
}
