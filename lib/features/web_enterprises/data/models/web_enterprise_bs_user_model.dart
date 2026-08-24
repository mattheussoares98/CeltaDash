import 'package:celta_dash/core/domain/domain.dart';

class WebEnterpriseBsUserModel {
  final String? name;
  final String? accessKey;
  final String? crossIdentityUsuario;

  const WebEnterpriseBsUserModel({
    required this.name,
    required this.accessKey,
    required this.crossIdentityUsuario,
  });

  factory WebEnterpriseBsUserModel.fromJson(Map json) =>
      WebEnterpriseBsUserModel(
        name:
            json['name'] as String? ??
            json['Usuario'] as String? ??
            json['Identificacao_Usuario'] as String?,
        accessKey: json['AccessKey'] as String?,
        crossIdentityUsuario: json['CrossIdentity_Usuario'] as String?,
      );

  factory WebEnterpriseBsUserModel.fromEntity(BsUserEntity entity) =>
      WebEnterpriseBsUserModel(
        name: entity.name,
        accessKey: entity.AccessKey,
        crossIdentityUsuario: entity.CrossIdentity_Usuario,
      );

  Map toJson() => {
    'name': name,
    'AccessKey': accessKey,
    'CrossIdentity_Usuario': crossIdentityUsuario,
  };

  BsUserEntity toEntity() => BsUserEntity(
    name: name,
    AccessKey: accessKey,
    CrossIdentity_Usuario: crossIdentityUsuario,
  );
}
