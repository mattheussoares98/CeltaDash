import 'package:equatable/equatable.dart';

class PaymentsStatisticsRowState extends Equatable {
  const PaymentsStatisticsRowState({
    required this.description,
    required this.totalValue,
    required this.totalQuantity,
    required this.averageTicket,
    required this.share,
  });

  final String description;
  final double totalValue;
  final int totalQuantity;
  final double averageTicket;
  final double share;

  @override
  List<Object?> get props => [
    description,
    totalValue,
    totalQuantity,
    averageTicket,
    share,
  ];
}
