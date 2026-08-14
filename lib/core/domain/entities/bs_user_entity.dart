// lib/core/domain/entities/bs_user_entity.dart
import 'package:equatable/equatable.dart';

class BsUserEntity extends Equatable {
  final String? name;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const BsUserEntity({
    required this.name,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  @override
  List<Object?> get props => [name, AccessKey, CrossIdentity_Usuario];

  BsUserEntity copyWith({
    String? name,
    String? AccessKey,
    String? CrossIdentity_Usuario,
    bool? annulName,
    bool? annulAccessKey,
    bool? annulCrossIdentity_Usuario,
  }) => BsUserEntity(
    name: annulName == true ? null : name ?? this.name,
    AccessKey: annulAccessKey == true ? null : AccessKey ?? this.AccessKey,
    CrossIdentity_Usuario: annulCrossIdentity_Usuario == true
        ? null
        : CrossIdentity_Usuario ?? this.CrossIdentity_Usuario,
  );
}
