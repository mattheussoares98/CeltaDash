import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class EnterprisesManagerPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  FirebaseEnterpriseViewModel? selectedEnterprise;
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
}
