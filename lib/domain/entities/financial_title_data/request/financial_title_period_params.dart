import 'package:equatable/equatable.dart';

/// Inclusive date range sent to the financial-title data endpoint.
class FinancialTitlePeriodParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const FinancialTitlePeriodParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
