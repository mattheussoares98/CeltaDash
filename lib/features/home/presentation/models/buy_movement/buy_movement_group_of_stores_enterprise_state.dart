import 'package:equatable/equatable.dart';

class BuyMovementGroupOfStoresEnterpriseState extends Equatable {
  final int id;
  final String name;
  final double totalValue;

  const BuyMovementGroupOfStoresEnterpriseState({
    required this.id,
    required this.name,
    required this.totalValue,
  });

  @override
  List<Object> get props => [id, name, totalValue];
}
