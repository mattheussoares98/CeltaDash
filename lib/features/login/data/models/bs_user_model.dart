// lib/features/login/data/models/bs_user_model.dart
import 'package:celta_dash/core/domain/domain.dart';

class BsUserModel {
  final String? name;
  final String? accessKey;
  final String? crossIdentityUsuario;

  const BsUserModel({this.name, this.accessKey, this.crossIdentityUsuario});

  factory BsUserModel.fromJson(Map json) {
    return BsUserModel(
      name:
          json['name'] as String? ??
          json['Usuario'] as String? ??
          json['Identificacao_Usuario'] as String?,
      accessKey: json['AccessKey'] as String?,
      crossIdentityUsuario: json['CrossIdentity_Usuario'] as String?,
    );
  }

  Map toJson() {
    return {
      'name': name,
      'AccessKey': accessKey,
      'CrossIdentity_Usuario': crossIdentityUsuario,
    };
  }

  factory BsUserModel.fromEntity(BsUserEntity entity) {
    return BsUserModel(
      name: entity.name,
      accessKey: entity.AccessKey,
      crossIdentityUsuario: entity.CrossIdentity_Usuario,
    );
  }

  BsUserEntity toEntity() {
    return BsUserEntity(
      name: name,
      AccessKey: accessKey,
      CrossIdentity_Usuario: crossIdentityUsuario,
    );
  }
}
