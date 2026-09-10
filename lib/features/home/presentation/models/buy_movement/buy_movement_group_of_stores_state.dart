import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:equatable/equatable.dart';

class BuyMovementGroupOfStoresState extends Equatable {
  final List<BuyMovementGroupOfStoresEnterpriseState> enterprises;

  const BuyMovementGroupOfStoresState({required this.enterprises});

  bool get hasMultipleEnterprises => enterprises.length > 1;

  @override
  List<Object> get props => [enterprises];
}
