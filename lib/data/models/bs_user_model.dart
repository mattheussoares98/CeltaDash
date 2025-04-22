import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class BsUserModel extends Equatable {
  final String? name;
  final String? accessKey;

  const BsUserModel({
    required this.name,
    required this.accessKey,
  });

  @override
  List<Object?> get props => [name, accessKey];

  factory BsUserModel.fromJson(Map json) => BsUserModel(
        name: json['name'],
        accessKey: json['accessKey'],
      );

  factory BsUserModel.fromEntity(BsUserEntity? entity) => BsUserModel(
        name: entity?.name,
        accessKey: entity?.accessKey,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'accessKey': accessKey,
      };

  BsUserEntity? toEntity() => BsUserEntity(
        name: name,
        accessKey: accessKey,
      );
}
