import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import 'firebase_enterprise_view_model.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<FirebaseEnterpriseViewModel>?> get enterprisesStream;
  FirebaseEnterpriseViewModel? get selectedEnterprise;

  Future<void> getEnterprises();
  void goToEnterpriseDetails(FirebaseEnterpriseViewModel enterprise);
  Future<void> changeEnterpriseUrl({
    required String newUrl,
    required DocumentReference<Map<String, dynamic>> docRef,
  });
  Future<void> addNewEnterprise({
    required String baseUrl,
    required String enterpriseName,
    required DocumentReference<Map<String, dynamic>> docRef,
    required String bsUserName,
    required String bsPassword,
    required void Function() doOnSucceeds,
  });
}
