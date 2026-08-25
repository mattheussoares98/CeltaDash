import 'package:equatable/equatable.dart';

class OperatorsStatisticsRowState extends Equatable {
  const OperatorsStatisticsRowState({
    required this.operatorName,
    required this.sales,
    required this.quantity,
  });

  final String operatorName;
  final double sales;
  final int quantity;

  OperatorsStatisticsRowState add({
    required double sales,
    required int quantity,
  }) => OperatorsStatisticsRowState(
    operatorName: operatorName,
    sales: this.sales + sales,
    quantity: this.quantity + quantity,
  );

  @override
  List<Object?> get props => [operatorName, sales, quantity];
}
