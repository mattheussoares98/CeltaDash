import 'package:equatable/equatable.dart';

class SaleMovementProductProductViewModel extends Equatable {
  final String? Id;
  final String? Plu;
  final String? Name;
  final String? PackingAbbreviation;
  final String? PackingQuantity;

  const SaleMovementProductProductViewModel({
    required this.Id,
    required this.Plu,
    required this.Name,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
  });

  @override
  List<Object?> get props => [
        Id,
        Plu,
        Name,
        PackingAbbreviation,
        PackingQuantity,
      ];
}
