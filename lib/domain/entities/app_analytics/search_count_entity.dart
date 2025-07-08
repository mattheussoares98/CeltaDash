import 'package:equatable/equatable.dart';

import '../../helpers/helpers.dart';
import '../entities.dart';

class SearchCountEntity extends Equatable {
  final ReportType reportType;
  final PeriodType periodType;
  final int count;

  const SearchCountEntity({
    required this.reportType,
    required this.periodType,
    required this.count,
  });

  @override
  List<Object?> get props => [reportType, periodType, count];
}
