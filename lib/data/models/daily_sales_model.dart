import 'package:equatable/equatable.dart';

class DailySalesModel extends Equatable {
  final int salesQuantity;
  final double totalAmountInDay;
  final double productsAverageBySale;

  const DailySalesModel({
    required this.salesQuantity,
    required this.totalAmountInDay,
    required this.productsAverageBySale,
  });

  @override
  List<Object?> get props => [
    salesQuantity,
    totalAmountInDay,
    productsAverageBySale,
  ];
}
