import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class CanceledSaleRowState extends Equatable {
  const CanceledSaleRowState(this.sale);

  final SaleMovementCollectionItemEntity sale;

  @override
  List<Object?> get props => [sale];
}
