import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:equatable/equatable.dart';

import '../../../ui/pages/pages.dart';

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

  SaleMovementCustomerViewModel toViewModel() => SaleMovementCustomerViewModel(
    SaleMovementId: SaleMovementId?.toString(),
    Id: Id?.toString(),
    Name: Name,
    CpfCnpj: CpfCnpj,
  );

  factory SaleMovementCustomerModel.fromViewModel(
    SaleMovementCustomerViewModel viewModel,
  ) => SaleMovementCustomerModel(
    SaleMovementId: viewModel.SaleMovementId?.toInt()!,
    Id: viewModel.Id?.toInt()!,
    Name: viewModel.Name,
    CpfCnpj: viewModel.CpfCnpj,
  );
}
