import 'package:equatable/equatable.dart';

class BuyMovementDataProductEntity extends Equatable {
  final int code;
  final String priceLookupCode;
  final String name;
  final String packingAbbreviation;
  final num packingQuantity;
  final num quantity;

  const BuyMovementDataProductEntity({
    required this.code,
    required this.priceLookupCode,
    required this.name,
    required this.packingAbbreviation,
    required this.packingQuantity,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    code,
    priceLookupCode,
    name,
    packingAbbreviation,
    packingQuantity,
    quantity,
  ];
}
