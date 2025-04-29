import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'bs_user_model.dart'; // ajuste o caminho se necessário

class FirebaseEnterpriseModel extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;

  const FirebaseEnterpriseModel({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
  });

  @override
  List<Object?> get props => [baseUrl, enterpriseName, bsUser];

  factory FirebaseEnterpriseModel.fromJson(Map json) => FirebaseEnterpriseModel(
        baseUrl: json['baseUrl'],
        enterpriseName: json['enterpriseName'],
        bsUser: json['bsUser'] == null
            ? null
            : BsUserModel.fromJson(json['bsUser']),
      );

  factory FirebaseEnterpriseModel.fromEntity(FirebaseEnterpriseEntity entity) =>
      FirebaseEnterpriseModel(
        baseUrl: entity.baseUrl,
        enterpriseName: entity.enterpriseName,
        bsUser: BsUserModel.fromEntity(entity.bsUser),
      );

  Map<String, dynamic> toJson() => {
        'baseUrl': baseUrl,
        'enterpriseName': enterpriseName,
        'bsUser': bsUser?.toJson(),
      };

  FirebaseEnterpriseEntity toEntity() => FirebaseEnterpriseEntity(
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        bsUser: bsUser?.toEntity(),
      );
}
