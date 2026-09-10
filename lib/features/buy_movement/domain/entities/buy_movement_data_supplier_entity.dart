import 'package:equatable/equatable.dart';

class BuyMovementDataSupplierEntity extends Equatable {
  final int code;
  final String name;

  const BuyMovementDataSupplierEntity({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}
