// lib/features/home/presentation/models/sales_statistics_row_state.dart
import 'package:equatable/equatable.dart';

class SalesStatisticsRowState extends Equatable {
  const SalesStatisticsRowState({
    required this.description,
    this.subtitle,
    required this.sales,
    required this.quantity,
    required this.averageTicket,
    required this.share,
  });

  final String description;
  final String? subtitle;
  final double sales;
  final double quantity;
  final double averageTicket;
  final double share;

  @override
  List<Object?> get props => [
    description,
    subtitle,
    sales,
    quantity,
    averageTicket,
    share,
  ];
}
