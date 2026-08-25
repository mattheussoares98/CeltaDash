// lib/features/home/presentation/models/financial_statistics_row_state.dart
import 'package:equatable/equatable.dart';

class FinancialStatisticsRowState extends Equatable {
  const FinancialStatisticsRowState({
    required this.description,
    this.subtitle,
    required this.receive,
    required this.pay,
    required this.balance,
  });

  final String description;
  final String? subtitle;
  final double receive;
  final double pay;
  final double balance;

  @override
  List<Object?> get props => [
    description,
    subtitle,
    receive,
    pay,
    balance,
  ];
}
