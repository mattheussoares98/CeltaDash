import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class EnterprisesManagerPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  List<FirebaseEnterpriseViewModel>? allEnterprises;

  Future<void> updateSelectedEnterprise(
    FirebaseEnterpriseViewModel enterprise,
  );

  Future<void> loadLocalEnterprises();
  Future<bool> addNewEnterprise({
    required String enterpriseName,
    required String userName,
    required String userPassword,
  });
  Future<void> removeEnterprise(String? enterpriseName);
}
