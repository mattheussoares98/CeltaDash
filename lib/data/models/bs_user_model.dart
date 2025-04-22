import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class BsUserModel extends Equatable {
  final String? name;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const BsUserModel({
    required this.name,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  @override
  List<Object?> get props => [
        name,
        AccessKey,
        CrossIdentity_Usuario,
      ];

  factory BsUserModel.fromJson(Map json) => BsUserModel(
        name: json['name'],
        AccessKey: json['AccessKey'],
        CrossIdentity_Usuario: json['CrossIdentity_Usuario'],
      );

  factory BsUserModel.fromEntity(BsUserEntity? entity) => BsUserModel(
        name: entity?.name,
        AccessKey: entity?.AccessKey,
        CrossIdentity_Usuario: entity?.CrossIdentity_Usuario,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'AccessKey': AccessKey,
        'CrossIdentity_Usuario': CrossIdentity_Usuario,
      };

  BsUserEntity? toEntity() => BsUserEntity(
        name: name,
        AccessKey: AccessKey,
        CrossIdentity_Usuario: CrossIdentity_Usuario,
      );
}
