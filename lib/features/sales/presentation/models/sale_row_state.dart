import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SaleRowState extends Equatable {
  const SaleRowState(this.sale);

  final SaleMovementCollectionItemEntity sale;

  @override
  List<Object?> get props => [sale];
}
