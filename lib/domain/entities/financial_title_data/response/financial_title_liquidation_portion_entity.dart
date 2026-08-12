import 'package:equatable/equatable.dart';

/// Liquidation portion returned by Commerce API.
class FinancialTitleLiquidationPortionEntity extends Equatable {
  final int? financialTitleLiquidationPortionCode;
  final int? financialTitlePortionCode;
  final num? value;
  final num? expenseAccessory;
  final num? expenseRegistry;
  final num? interest;
  final num? increment;
  final num? discount;
  final num? fine;
  final num? collectTax;
  final num? discountByAnticipatedPay;
  final DateTime? liquidationDate;

  const FinancialTitleLiquidationPortionEntity({
    required this.financialTitleLiquidationPortionCode,
    required this.financialTitlePortionCode,
    required this.value,
    required this.expenseAccessory,
    required this.expenseRegistry,
    required this.interest,
    required this.increment,
    required this.discount,
    required this.fine,
    required this.collectTax,
    required this.discountByAnticipatedPay,
    required this.liquidationDate,
  });

  @override
  List<Object?> get props => [
        financialTitleLiquidationPortionCode,
        financialTitlePortionCode,
        value,
        expenseAccessory,
        expenseRegistry,
        interest,
        increment,
        discount,
        fine,
        collectTax,
        discountByAnticipatedPay,
        liquidationDate,
      ];
}
