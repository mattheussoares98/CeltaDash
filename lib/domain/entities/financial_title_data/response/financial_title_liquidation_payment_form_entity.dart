import 'package:equatable/equatable.dart';

/// Liquidation payment form returned by Commerce API.
class FinancialTitleLiquidationPaymentFormEntity extends Equatable {
  final int? financialTitleLiquidationPortionPaymentFormCode;
  final int? financialTitleLiquidationPortionCode;
  final int? financialTitlePortionCode;
  final String? paymentFormDescription;
  final num? value;
  final num? expenseAccessory;
  final num? expenseRegistry;
  final num? interest;
  final num? increment;
  final num? discount;
  final num? fine;
  final num? discountByAnticipatedPay;
  final num? collectTax;

  const FinancialTitleLiquidationPaymentFormEntity({
    required this.financialTitleLiquidationPortionPaymentFormCode,
    required this.financialTitleLiquidationPortionCode,
    required this.financialTitlePortionCode,
    required this.paymentFormDescription,
    required this.value,
    required this.expenseAccessory,
    required this.expenseRegistry,
    required this.interest,
    required this.increment,
    required this.discount,
    required this.fine,
    required this.discountByAnticipatedPay,
    required this.collectTax,
  });

  @override
  List<Object?> get props => [
        financialTitleLiquidationPortionPaymentFormCode,
        financialTitleLiquidationPortionCode,
        financialTitlePortionCode,
        paymentFormDescription,
        value,
        expenseAccessory,
        expenseRegistry,
        interest,
        increment,
        discount,
        fine,
        discountByAnticipatedPay,
        collectTax,
      ];
}
