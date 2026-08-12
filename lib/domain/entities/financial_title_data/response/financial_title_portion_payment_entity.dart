import 'package:equatable/equatable.dart';

/// Portion payment returned by Commerce API.
class FinancialTitlePortionPaymentEntity extends Equatable {
  final int? financialTitlePortionCode;
  final String? paymentFormDescription;
  final num? value;
  final DateTime? liquidationDate;

  const FinancialTitlePortionPaymentEntity({
    required this.financialTitlePortionCode,
    required this.paymentFormDescription,
    required this.value,
    required this.liquidationDate,
  });

  @override
  List<Object?> get props => [
        financialTitlePortionCode,
        paymentFormDescription,
        value,
        liquidationDate,
      ];
}
