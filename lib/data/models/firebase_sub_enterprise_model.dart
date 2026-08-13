import 'package:celta_dash/utils/utils.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

class FirebaseSubEnterpriseModel extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;
  final bool? enabled;

  const FirebaseSubEnterpriseModel({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
    required this.enabled,
  });

  @override
  List<Object?> get props => [id, name, personalizedCode, cnpj, enabled];

  factory FirebaseSubEnterpriseModel.fromJson(Map json) =>
      FirebaseSubEnterpriseModel(
        id: json['id'],
        name: json['name'],
        personalizedCode: json['personalizedCode'],
        cnpj: json['cnpj'],
        enabled: json['enabled'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'personalizedCode': personalizedCode,
    'cnpj': cnpj,
    'enabled': enabled,
  };

  factory FirebaseSubEnterpriseModel.fromEntity(
    FirebaseSubEnterpriseEntity entity,
  ) => FirebaseSubEnterpriseModel(
    id: entity.id,
    name: entity.name,
    personalizedCode: entity.personalizedCode,
    cnpj: entity.cnpj,
    enabled: entity.enabled,
  );

  FirebaseSubEnterpriseEntity toEntity() => FirebaseSubEnterpriseEntity(
    id: id,
    name: name,
    personalizedCode: personalizedCode,
    cnpj: cnpj,
    enabled: enabled,
  );

  factory FirebaseSubEnterpriseModel.fromViewModel(
    FirebaseSubEnterpriseViewModel viewModel,
  ) {
    return FirebaseSubEnterpriseModel(
      id: viewModel.id?.toInt(),
      name: viewModel.name,
      personalizedCode: viewModel.personalizedCode,
      cnpj: viewModel.cnpj,
      enabled: viewModel.enabled == "true",
    );
  }

  FirebaseSubEnterpriseViewModel toViewModel() =>
      FirebaseSubEnterpriseViewModel(
        id: id.toString(),
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
        enabled: enabled?.toString(),
      );
}
