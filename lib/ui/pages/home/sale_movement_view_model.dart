import 'package:equatable/equatable.dart';

class SaleMovementViewModel extends Equatable {
  //TODO create toViewModel and fromViewModel in saleMovementModel
  final String? Date;
  final String? LiquidValue;
  final String? Year;
  final String? Month;
  final String? Hour;
  final String? Enterprise;
  final String? Product;
  final String? ProductDepartment;
  final String? ProductSection;
  final String? PaymentFinalization;
  final String? PaymentModality;

  const SaleMovementViewModel({
    required this.Date,
    required this.LiquidValue,
    required this.Year,
    required this.Month,
    required this.Hour,
    required this.Enterprise,
    required this.Product,
    required this.ProductDepartment,
    required this.ProductSection,
    required this.PaymentFinalization,
    required this.PaymentModality,
  });

  @override
  List<Object?> get props => [
        Enterprise,
        LiquidValue,
        Year,
        Month,
        Date,
        Hour,
        Product,
        ProductDepartment,
        ProductSection,
        PaymentFinalization,
        PaymentModality,
      ];
}
