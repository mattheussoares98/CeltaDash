import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'bs_user_model.dart'; // ajuste o caminho se necessário

class EnterpriseModel extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;

  const EnterpriseModel({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
  });

  @override
  List<Object?> get props => [baseUrl, enterpriseName, bsUser];

  factory EnterpriseModel.fromJson(Map json) => EnterpriseModel(
        baseUrl: json['baseUrl'],
        enterpriseName: json['enterpriseName'],
        bsUser: json['bsUser'] == null
            ? null
            : BsUserModel.fromJson(json['bsUser']),
      );

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        baseUrl: entity.baseUrl,
        enterpriseName: entity.enterpriseName,
        bsUser: BsUserModel.fromEntity(entity.bsUser),
      );

  Map<String, dynamic> toJson() => {
        'baseUrl': baseUrl,
        'enterpriseName': enterpriseName,
        'bsUser': bsUser?.toJson(),
      };

  EnterpriseEntity toEntity() => EnterpriseEntity(
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        bsUser: bsUser?.toEntity(),
      );
}
