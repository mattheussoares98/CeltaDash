// lib/features/home/presentation/models/products_statistics_row_state.dart
import 'package:equatable/equatable.dart';

class ProductsStatisticsRowState extends Equatable {
  const ProductsStatisticsRowState({
    required this.productName,
    this.productCode,
    required this.sales,
    required this.quantity,
    required this.averagePrice,
    required this.cost,
    required this.averageCost,
    required this.profit,
    required this.margin,
  });

  final String productName;
  final String? productCode;
  final double sales;
  final double quantity;
  final double averagePrice;
  final double cost;
  final double averageCost;
  final double profit;
  final double margin;

  @override
  List<Object?> get props => [
    productName,
    productCode,
    sales,
    quantity,
    averagePrice,
    cost,
    averageCost,
    profit,
    margin,
  ];
}
