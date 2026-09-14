import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataRowEntity extends Equatable {
  final int? enterpriseCode;
  final DateTime? date;
  final BuyMovementDataProductEntity? product;
  final BuyMovementDataProductDepartmentEntity? productDepartment;
  final BuyMovementDataSupplierEntity? supplier;
  final num totalValue;

  const BuyMovementDataRowEntity({
    this.enterpriseCode,
    this.date,
    this.product,
    this.productDepartment,
    this.supplier,
    required this.totalValue,
  });

  @override
  List<Object?> get props => [
    enterpriseCode,
    date,
    product,
    productDepartment,
    supplier,
    totalValue,
  ];
}
