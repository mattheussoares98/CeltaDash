import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

class EnterpriseModel extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const EnterpriseModel({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        personalizedCode,
        cnpj,
      ];

  factory EnterpriseModel.fromJson(Map json) => EnterpriseModel(
        id: json['id'],
        name: json['name'],
        personalizedCode: json['personalizedCode'],
        cnpj: json['cnpj'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'personalizedCode': personalizedCode,
        'cnpj': cnpj,
      };

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        id: entity.id,
        name: entity.name,
        personalizedCode: entity.personalizedCode,
        cnpj: entity.cnpj,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
        id: id,
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
      );

  factory EnterpriseModel.fromViewModel(EnterpriseViewModel viewModel) {
    return EnterpriseModel(
      id: viewModel.id?.toInt(),
      name: viewModel.name,
      personalizedCode: viewModel.personalizedCode,
      cnpj: viewModel.cnpj,
    );
  }

  EnterpriseViewModel toViewModel() => EnterpriseViewModel(
        id: id.toString(),
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
      );
}
