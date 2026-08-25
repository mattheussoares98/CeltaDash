// lib/features/home/presentation/models/financial_group_of_stores_enterprise_state.dart
import 'package:equatable/equatable.dart';

class FinancialGroupOfStoresEnterpriseState extends Equatable {
  const FinancialGroupOfStoresEnterpriseState({
    required this.id,
    required this.name,
    required this.receiveLiquidValue,
    required this.payLiquidValue,
  });

  final int? id;
  final String name;
  final double receiveLiquidValue;
  final double payLiquidValue;

  double get balance => receiveLiquidValue - payLiquidValue;
  double get totalVolume => receiveLiquidValue + payLiquidValue;

  @override
  List<Object?> get props => [id, name, receiveLiquidValue, payLiquidValue];
}
