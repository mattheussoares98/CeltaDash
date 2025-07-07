import '../../../domain/entities/entities.dart';

class SearchCountModel extends SearchCountEntity {
  const SearchCountModel({
    required super.reportType,
    required super.reportPeriod,
    required super.count,
  });

  factory SearchCountModel.fromJson(Map<String, dynamic> json) {
    return SearchCountModel(
      reportType: ReportType.values.byName(json['reportType']),
      reportPeriod: ReportPeriod.values.byName(json['reportPeriod']),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reportType': reportType.name,
        'reportPeriod': reportPeriod.name,
        'count': count,
      };
}
