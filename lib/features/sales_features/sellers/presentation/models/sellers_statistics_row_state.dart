// lib/features/sellers/presentation/models/sellers_statistics_row_state.dart
import 'package:equatable/equatable.dart';

class SellersStatisticsRowState extends Equatable {
  const SellersStatisticsRowState({
    required this.sellerName,
    required this.sales,
    required this.quantity,
  });

  final String sellerName;
  final double sales;
  final int quantity;

  SellersStatisticsRowState add({
    required double sales,
    required int quantity,
  }) => SellersStatisticsRowState(
    sellerName: sellerName,
    sales: this.sales + sales,
    quantity: this.quantity + quantity,
  );

  @override
  List<Object?> get props => [sellerName, sales, quantity];
}
