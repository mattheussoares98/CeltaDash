// lib/core/data/models/firebase_enterprise_model.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/login/data/models/models.dart';
import 'package:equatable/equatable.dart';

class FirebaseEnterpriseModel extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;
  final List<FirebaseSubEnterpriseModel>? subEnterprises;
  final String? firebaseId;

  const FirebaseEnterpriseModel({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.subEnterprises,
    required this.firebaseId,
  });

  @override
  List<Object?> get props => [
    baseUrl,
    enterpriseName,
    bsUser,
    subEnterprises,
    firebaseId,
  ];

  factory FirebaseEnterpriseModel.fromJson(Map json, {String? documentId}) =>
      FirebaseEnterpriseModel(
        baseUrl: json['baseUrl'] as String?,
        enterpriseName: json['enterpriseName'] as String?,
        firebaseId: documentId ?? json['firebaseId'] as String?,
        bsUser: json['bsUser'] == null
            ? null
            : BsUserModel.fromJson(json['bsUser'] as Map),
        subEnterprises: (json['subEnterprises'] as List?)
            ?.map<FirebaseSubEnterpriseModel>(
              (x) => FirebaseSubEnterpriseModel.fromJson(x as Map),
            )
            .toList(),
      );

  factory FirebaseEnterpriseModel.fromEntity(FirebaseEnterpriseEntity entity) =>
      FirebaseEnterpriseModel(
        baseUrl: entity.baseUrl,
        enterpriseName: entity.enterpriseName,
        firebaseId: entity.firebaseId,
        bsUser: entity.bsUser == null
            ? null
            : BsUserModel.fromEntity(entity.bsUser!),
        subEnterprises: entity.firebaseSubEnterprises
            ?.map<FirebaseSubEnterpriseModel>(
              (x) => FirebaseSubEnterpriseModel.fromEntity(x),
            )
            .toList(),
      );

  Map toJson() => {
    'baseUrl': baseUrl,
    'enterpriseName': enterpriseName,
    'firebaseId': firebaseId,
    'bsUser': bsUser?.toJson(),
    'subEnterprises': subEnterprises?.map((x) => x.toJson()).toList(),
  };

  FirebaseEnterpriseEntity toEntity() => FirebaseEnterpriseEntity(
    baseUrl: baseUrl,
    enterpriseName: enterpriseName,
    firebaseId: firebaseId,
    bsUser: bsUser?.toEntity(),
    firebaseSubEnterprises: subEnterprises?.map((x) => x.toEntity()).toList(),
  );
}
