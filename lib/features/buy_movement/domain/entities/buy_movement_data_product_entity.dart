import 'package:equatable/equatable.dart';

class BuyMovementDataProductEntity extends Equatable {
  final int code;
  final int packingCode;
  final String name;
  final num quantity;

  const BuyMovementDataProductEntity({
    required this.code,
    required this.packingCode,
    required this.name,
    required this.quantity,
  });

  @override
  List<Object?> get props => [code, packingCode, name, quantity];
}
