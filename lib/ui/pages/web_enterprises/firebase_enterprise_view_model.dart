import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';
import 'firebase_sub_enterprise_view_model.dart';

class FirebaseEnterpriseViewModel extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;
  final List<FirebaseSubEnterpriseViewModel>? firebaseSubEnterprises;
  final String? firebaseId;

  const FirebaseEnterpriseViewModel({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.firebaseSubEnterprises,
    required this.firebaseId,
  });

  @override
  List<Object?> get props =>
      [baseUrl, enterpriseName, firebaseSubEnterprises, firebaseId];
}
