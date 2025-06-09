import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

class EcEnterpriseModel extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const EcEnterpriseModel({
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

  factory EcEnterpriseModel.fromJson(Map json) => EcEnterpriseModel(
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

  factory EcEnterpriseModel.fromEntity(EcEnterpriseEntity entity) =>
      EcEnterpriseModel(
        id: entity.id,
        name: entity.name,
        personalizedCode: entity.personalizedCode,
        cnpj: entity.cnpj,
      );

  EcEnterpriseEntity toEntity() => EcEnterpriseEntity(
        id: id,
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
      );

  factory EcEnterpriseModel.fromViewModel(EcEnterpriseViewModel viewModel) {
    return EcEnterpriseModel(
      id: viewModel.id?.toInt(),
      name: viewModel.name,
      personalizedCode: viewModel.personalizedCode,
      cnpj: viewModel.cnpj,
    );
  }

  EcEnterpriseViewModel toViewModel() => EcEnterpriseViewModel(
        id: id.toString(),
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
      );
}
