import 'package:equatable/equatable.dart';

import '../entities.dart';

class SearchCountEntity extends Equatable {
  final ReportType reportType;
  final ReportPeriod reportPeriod;
  final int count;

  const SearchCountEntity({
    required this.reportType,
    required this.reportPeriod,
    required this.count,
  });

  @override
  List<Object?> get props => [reportType, reportPeriod, count];
}
