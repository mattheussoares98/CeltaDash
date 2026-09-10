import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataRowEntity extends Equatable {
  final DateTime? date;
  final BuyMovementDataProductEntity? product;
  final BuyMovementDataSupplierEntity? supplier;
  final num totalValue;

  const BuyMovementDataRowEntity({
    this.date,
    this.product,
    this.supplier,
    required this.totalValue,
  });

  @override
  List<Object?> get props => [date, product, supplier, totalValue];
}
