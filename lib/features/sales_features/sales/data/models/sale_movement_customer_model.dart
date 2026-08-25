import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

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
  List<Object?> get props => [SaleMovementId, Id, Name, CpfCnpj];

  factory SaleMovementCustomerModel.fromJson(Map json) =>
      SaleMovementCustomerModel(
        SaleMovementId: json['saleMovementId'],
        Id: json['id'],
        Name: json['name'],
        CpfCnpj: json['cpfCnpj'],
      );

  factory SaleMovementCustomerModel.fromEntity(
    SaleMovementCustomerEntity? entity,
  ) => SaleMovementCustomerModel(
    SaleMovementId: entity?.SaleMovementId,
    Id: entity?.Id,
    Name: entity?.Name,
    CpfCnpj: entity?.CpfCnpj,
  );

  Map<String, dynamic> toJson() => {
    'saleMovementId': SaleMovementId,
    'id': Id,
    'name': Name,
    'cpfCnpj': CpfCnpj,
  };

  SaleMovementCustomerEntity toEntity() => SaleMovementCustomerEntity(
    SaleMovementId: SaleMovementId,
    Id: Id,
    Name: Name,
    CpfCnpj: CpfCnpj,
  );

}
