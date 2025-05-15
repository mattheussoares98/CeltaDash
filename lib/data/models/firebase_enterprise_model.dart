import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import './models.dart';

class FirebaseEnterpriseModel extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;
  final List<EnterpriseModel>?
      subEnterprises; //save in firebase the same enterprise that return in RemoteLoadEnterprises

  const FirebaseEnterpriseModel({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.subEnterprises,
  });

  @override
  List<Object?> get props => [baseUrl, enterpriseName, bsUser];

  factory FirebaseEnterpriseModel.fromJson(Map json) => FirebaseEnterpriseModel(
        baseUrl: json['baseUrl'],
        enterpriseName: json['enterpriseName'],
        bsUser: json['bsUser'] == null
            ? null
            : BsUserModel.fromJson(json['bsUser']),
        subEnterprises: json["subEnterprises"]
            ?.map((x) => EnterpriseModel.fromJson(x))
            .toList(),
      );

  factory FirebaseEnterpriseModel.fromEntity(FirebaseEnterpriseEntity entity) =>
      FirebaseEnterpriseModel(
        baseUrl: entity.baseUrl,
        enterpriseName: entity.enterpriseName,
        bsUser: BsUserModel.fromEntity(entity.bsUser),
        subEnterprises: entity.subEnterprises
            ?.map((e) => EnterpriseModel.fromEntity(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'baseUrl': baseUrl,
        'enterpriseName': enterpriseName,
        'bsUser': bsUser?.toJson(),
        'subEnterprises': subEnterprises?.map((e) => e.toJson()).toList(),
      };

  FirebaseEnterpriseEntity toEntity() => FirebaseEnterpriseEntity(
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        bsUser: bsUser?.toEntity(),
        subEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
      );
}
