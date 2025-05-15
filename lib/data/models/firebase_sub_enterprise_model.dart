import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class FirebaseSubEnterpriseModel extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const FirebaseSubEnterpriseModel({
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

  factory FirebaseSubEnterpriseModel.fromJson(Map json) =>
      FirebaseSubEnterpriseModel(
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

  factory FirebaseSubEnterpriseModel.fromEntity(
          FirebaseSubEnterpriseEntity entity) =>
      FirebaseSubEnterpriseModel(
        id: entity.id,
        name: entity.name,
        personalizedCode: entity.personalizedCode,
        cnpj: entity.cnpj,
      );

  FirebaseSubEnterpriseEntity toEntity() => FirebaseSubEnterpriseEntity(
        id: id,
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
      );

  // factory FirebaseSubEnterpriseModel.fromViewModel(
  //     EnterpriseViewModel viewModel) {
  //   return FirebaseSubEnterpriseModel(
  //     id: viewModel.id?.toInt(),
  //     name: viewModel.name,
  //     personalizedCode: viewModel.personalizedCode,
  //     cnpj: viewModel.cnpj,
  //   );
  // }

  // EnterpriseViewModel toViewModel() => EnterpriseViewModel(
  //       id: id.toString(),
  //       name: name,
  //       personalizedCode: personalizedCode,
  //       cnpj: cnpj,
  //     );
}
