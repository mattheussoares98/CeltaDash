import 'package:equatable/equatable.dart';
import 'entities.dart';

class FirebaseEnterpriseEntity extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserEntity? bsUser;
  final List<
          EnterpriseEntity>? //TODO change this entity to firebaseSubEnterprise because after that will have different params
      firebaseSubEnterprises;
  final String? firebaseId;

  const FirebaseEnterpriseEntity({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.firebaseSubEnterprises,
    required this.firebaseId,
  });

  @override
  List<Object?> get props =>
      [baseUrl, enterpriseName, bsUser, firebaseSubEnterprises, firebaseId];
}
