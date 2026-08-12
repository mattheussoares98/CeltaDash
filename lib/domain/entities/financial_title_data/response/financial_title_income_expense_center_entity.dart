import 'package:equatable/equatable.dart';

/// Income/expense center returned by Commerce API.
class FinancialTitleIncomeExpenseCenterEntity extends Equatable {
  final int? code;
  final String? personalizedCode;
  final String? description;

  const FinancialTitleIncomeExpenseCenterEntity({
    required this.code,
    required this.personalizedCode,
    required this.description,
  });

  @override
  List<Object?> get props => [code, personalizedCode, description];
}
