// lib/features/home/presentation/models/financial_group_of_stores_state.dart
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:equatable/equatable.dart';

class FinancialGroupOfStoresState extends Equatable {
  const FinancialGroupOfStoresState({required this.enterprises});

  final List<FinancialGroupOfStoresEnterpriseState> enterprises;

  bool get hasMultipleEnterprises => enterprises.length > 1;

  @override
  List<Object?> get props => [enterprises];
}
