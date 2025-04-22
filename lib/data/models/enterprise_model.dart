import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class EnterpriseModel extends Equatable {
  final String? ccsUrl;
  final String? user;
  final String? accessKey;
  final String? enterpriseName;

  const EnterpriseModel({
    required this.ccsUrl,
    required this.user,
    required this.accessKey,
    required this.enterpriseName,
  });

  @override
  List<Object?> get props => [ccsUrl, user, accessKey, enterpriseName];

  factory EnterpriseModel.fromJson(Map json) => EnterpriseModel(
    ccsUrl: json['ccsUrl'],
    user: json['user'],
    accessKey: json['accessKey'],
    enterpriseName: json['enterpriseName'],
  );

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        ccsUrl: entity.ccsUrl,
        user: entity.user,
        accessKey: entity.accessKey,
        enterpriseName: entity.enterpriseName,
      );

  Map<String, dynamic> toJson() => {
    'ccsUrl': ccsUrl,
    'user': user,
    'accessKey': accessKey,
    'enterpriseName': enterpriseName,
  };

  EnterpriseEntity toEntity() => EnterpriseEntity(
    ccsUrl: ccsUrl,
    user: user,
    accessKey: accessKey,
    enterpriseName: enterpriseName,
  );
}
