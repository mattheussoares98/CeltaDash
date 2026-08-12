import 'package:celta_dash/domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';

class SearchCountModel extends SearchCountEntity {
  const SearchCountModel({
    required super.reportType,
    required super.periodType,
    required super.count,
  });

  factory SearchCountModel.fromJson(Map<String, dynamic> json) {
    return SearchCountModel(
      reportType: ReportType.values.byName(json['reportType']),
      periodType: PeriodType.values.byName(json['periodType']),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reportType': reportType.name,
        'periodType': periodType.name,
        'count': count,
      };

  factory SearchCountModel.fromEntity(SearchCountEntity entity) {
    return SearchCountModel(
      reportType: entity.reportType,
      periodType: entity.periodType,
      count: entity.count,
    );
  }
}
