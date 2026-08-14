import 'package:equatable/equatable.dart';

class DailyComparisonState extends Equatable {
  const DailyComparisonState({
    required this.selectedDate,
    required this.comparisonDate,
    required this.selectedLiquidValue,
    required this.comparisonLiquidValue,
    required this.selectedCustomers,
    required this.comparisonCustomers,
  });

  final DateTime selectedDate;
  final DateTime comparisonDate;
  final num selectedLiquidValue;
  final num comparisonLiquidValue;
  final int selectedCustomers;
  final int comparisonCustomers;

  double get percentageDifference {
    if (selectedLiquidValue == 0) return 0;
    if (comparisonLiquidValue == 0) return 100;
    return selectedLiquidValue / comparisonLiquidValue * 100 - 100;
  }

  double get selectedAverageTicket =>
      selectedCustomers == 0 ? 0 : selectedLiquidValue / selectedCustomers;

  double get comparisonAverageTicket => comparisonCustomers == 0
      ? 0
      : comparisonLiquidValue / comparisonCustomers;

  @override
  List<Object> get props => [
    selectedDate,
    comparisonDate,
    selectedLiquidValue,
    comparisonLiquidValue,
    selectedCustomers,
    comparisonCustomers,
  ];
}
