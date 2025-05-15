import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import './models.dart';

class FirebaseEnterpriseModel extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;
  final List<EnterpriseModel>?
      subEnterprises; //save in firebase the same enterprise that return in RemoteLoadEnterprises
  final String? firebaseId;

  const FirebaseEnterpriseModel({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.subEnterprises,
    required this.firebaseId,
  });

  @override
  List<Object?> get props => [baseUrl, enterpriseName, bsUser, firebaseId];

  factory FirebaseEnterpriseModel.fromJson(
    Map json, {
    String? documentId,
  }) =>
      FirebaseEnterpriseModel(
        baseUrl: json['baseUrl'],
        enterpriseName: json['enterpriseName'],
        firebaseId: documentId ?? json['firebaseId'],
        bsUser: json['bsUser'] == null
            ? null
            : BsUserModel.fromJson(json['bsUser']),
        subEnterprises: json["subEnterprises"]
            ?.map<EnterpriseModel>((x) => EnterpriseModel.fromJson(x))
            .toList(),
      );

  factory FirebaseEnterpriseModel.fromEntity(FirebaseEnterpriseEntity entity) =>
      FirebaseEnterpriseModel(
        baseUrl: entity.baseUrl,
        enterpriseName: entity.enterpriseName,
        firebaseId: entity.firebaseId,
        bsUser: BsUserModel.fromEntity(entity.bsUser),
        subEnterprises: entity.firebaseSubEnterprises
            ?.map((e) => EnterpriseModel.fromEntity(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'baseUrl': baseUrl,
        'enterpriseName': enterpriseName,
        'firebaseId': firebaseId,
        'bsUser': bsUser?.toJson(),
        'subEnterprises': subEnterprises?.map((e) => e.toJson()).toList(),
      };

  FirebaseEnterpriseEntity toEntity() => FirebaseEnterpriseEntity(
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        firebaseId: firebaseId,
        bsUser: bsUser?.toEntity(),
        firebaseSubEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
      );
}
