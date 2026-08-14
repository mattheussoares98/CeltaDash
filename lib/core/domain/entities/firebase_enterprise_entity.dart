// lib/core/domain/entities/firebase_enterprise_entity.dart
import 'package:equatable/equatable.dart';

import 'bs_user_entity.dart';
import 'firebase_sub_enterprise_entity.dart';

class FirebaseEnterpriseEntity extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserEntity? bsUser;
  final List<FirebaseSubEnterpriseEntity>? firebaseSubEnterprises;
  final String? firebaseId;

  const FirebaseEnterpriseEntity({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.firebaseSubEnterprises,
    required this.firebaseId,
  });

  @override
  List<Object?> get props => [
        baseUrl,
        enterpriseName,
        bsUser,
        firebaseSubEnterprises,
        firebaseId,
      ];
}
