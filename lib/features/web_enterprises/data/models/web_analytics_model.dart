import 'package:celta_dash/features/web_enterprises/data/models/models.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';

class WebAnalyticsModel {
  final List<WebAnalyticsSearchCountModel> searchCounts;
  final List<WebAnalyticsUserModel> users;
  final String enterprise;

  const WebAnalyticsModel({
    required this.searchCounts,
    required this.users,
    required this.enterprise,
  });

  factory WebAnalyticsModel.fromJson(Map json, {required String enterpriseId}) {
    final searchCounts = <WebAnalyticsSearchCountModel>[];
    final users = <WebAnalyticsUserModel>[];

    for (final MapEntry(:key, :value) in json.entries) {
      if (key == 'users' && value is List) {
        users.addAll(
          value.whereType<Map>().map(WebAnalyticsUserModel.fromJson),
        );
        continue;
      }

      final parts = key.toString().split('-');
      if (parts.length != 2 || value is! int) continue;

      final reportType = WebAnalyticsReportType.values
          .where((type) => type.name == parts.first)
          .firstOrNull;
      final periodType = WebAnalyticsPeriodType.values
          .where((type) => type.name == parts.last)
          .firstOrNull;
      if (reportType == null || periodType == null) continue;

      searchCounts.add(
        WebAnalyticsSearchCountModel(
          reportType: reportType,
          periodType: periodType,
          count: value,
        ),
      );
    }

    return WebAnalyticsModel(
      searchCounts: searchCounts,
      users: users,
      enterprise: enterpriseId,
    );
  }

  factory WebAnalyticsModel.fromEntity(WebAnalyticsEntity entity) =>
      WebAnalyticsModel(
        searchCounts: entity.searchCounts
            .map(WebAnalyticsSearchCountModel.fromEntity)
            .toList(growable: false),
        users: entity.users
            .map(WebAnalyticsUserModel.fromEntity)
            .toList(growable: false),
        enterprise: entity.enterprise,
      );

  Map toJson() => {
    for (final searchCount in searchCounts)
      '${searchCount.reportType.name}-${searchCount.periodType.name}':
          searchCount.count,
    'users': users.map((user) => user.toJson()).toList(),
  };

  WebAnalyticsEntity toEntity() => WebAnalyticsEntity(
    searchCounts: searchCounts
        .map((searchCount) => searchCount.toEntity())
        .toList(growable: false),
    users: users.map((user) => user.toEntity()).toList(growable: false),
    enterprise: enterprise,
  );
}
