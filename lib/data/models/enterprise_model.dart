import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'bs_user_model.dart'; // ajuste o caminho se necessário

class EnterpriseModel extends Equatable {
  final String? ccsUrl;
  final String? enterpriseName;
  final BsUserModel? bsUser;

  const EnterpriseModel({
    required this.ccsUrl,
    required this.enterpriseName,
    required this.bsUser,
  });

  @override
  List<Object?> get props => [ccsUrl, enterpriseName, bsUser];

  factory EnterpriseModel.fromJson(Map json) => EnterpriseModel(
        ccsUrl: json['ccsUrl'],
        enterpriseName: json['enterpriseName'],
        bsUser: json['bsUser'] == null
            ? null
            : BsUserModel.fromJson(json['bsUser']),
      );

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        ccsUrl: entity.ccsUrl,
        enterpriseName: entity.enterpriseName,
        bsUser: BsUserModel.fromEntity(entity.bsUser),
      );

  Map<String, dynamic> toJson() => {
        'ccsUrl': ccsUrl,
        'enterpriseName': enterpriseName,
        'bsUser': bsUser?.toJson(),
      };

  EnterpriseEntity toEntity() => EnterpriseEntity(
        ccsUrl: ccsUrl,
        enterpriseName: enterpriseName,
        bsUser: bsUser?.toEntity(),
      );
}
