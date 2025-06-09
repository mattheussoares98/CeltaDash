import 'package:equatable/equatable.dart';

class SaleMovementCustomerEntity extends Equatable {
  final int? SaleMovementId;
  final int? Id;
  final String? Name;
  final String? CpfCnpj;

  const SaleMovementCustomerEntity({
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
}
