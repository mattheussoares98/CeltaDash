import 'package:equatable/equatable.dart';

class SaleMovementCustomerViewModel extends Equatable {
  final String? SaleMovementId;
  final String? Id;
  final String? Name;
  final String? CpfCnpj;

  const SaleMovementCustomerViewModel({
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
