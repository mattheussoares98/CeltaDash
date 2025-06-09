import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SaleMovementCustomerModel extends Equatable {
  final int? SaleMovementId;
  final int? Id;
  final String? Name;
  final String? CpfCnpj;

  const SaleMovementCustomerModel({
    required this.SaleMovementId,
    required this.Id,
    required this.Name,
    required this.CpfCnpj,
  });

  @override
  List<Object?> get props => [
        SaleMovementId,
        Id,
        Name,
        CpfCnpj,
      ];

  factory SaleMovementCustomerModel.fromJson(Map json) =>
      SaleMovementCustomerModel(
        SaleMovementId: json['SaleMovementId'],
        Id: json['Id'],
        Name: json['Name'],
        CpfCnpj: json['CpfCnpj'],
      );

  factory SaleMovementCustomerModel.fromEntity(
          SaleMovementCustomerEntity? entity) =>
      SaleMovementCustomerModel(
        SaleMovementId: entity?.SaleMovementId,
        Id: entity?.Id,
        Name: entity?.Name,
        CpfCnpj: entity?.CpfCnpj,
      );

  Map<String, dynamic> toJson() => {
        'SaleMovementId': SaleMovementId,
        'Id': Id,
        'Name': Name,
        'CpfCnpj': CpfCnpj,
      };

  SaleMovementCustomerEntity toEntity() => SaleMovementCustomerEntity(
        SaleMovementId: SaleMovementId,
        Id: Id,
        Name: Name,
        CpfCnpj: CpfCnpj,
      );
}
