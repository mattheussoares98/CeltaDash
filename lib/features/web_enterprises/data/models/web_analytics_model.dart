import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';

class WebAnalyticsModel {
  final List<SearchCountEntity> searchCounts;
  final List<ActiveUserEntity> users;
  final String enterprise;

  const WebAnalyticsModel({
    required this.searchCounts,
    required this.users,
    required this.enterprise,
  });

  factory WebAnalyticsModel.fromJson(Map json, {required String enterpriseId}) {
    final searchCounts = <SearchCountEntity>[];
    final users = <ActiveUserEntity>[];

    for (final MapEntry(:key, :value) in json.entries) {
      if (key == 'users' && value is List) {
        users.addAll(
          value.whereType<Map>().map(
            (user) => ActiveUserModel.fromJson(Map<String, dynamic>.from(user)),
          ),
        );
        continue;
      }

      final parts = key.toString().split('-');
      if (parts.length != 2 || value is! int) continue;

      final reportType = ReportType.values
          .where((type) => type.name == parts.first)
          .firstOrNull;
      final periodType = PeriodType.values
          .where((type) => type.name == parts.last)
          .firstOrNull;
      if (reportType == null || periodType == null) continue;

      searchCounts.add(
        SearchCountEntity(
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

  factory WebAnalyticsModel.fromEntity(MonthlyAnalyticsEntity entity) =>
      WebAnalyticsModel(
        searchCounts: entity.searchCounts,
        users: entity.users,
        enterprise: entity.enterprise,
      );

  Map toJson() => {
    for (final searchCount in searchCounts)
      '${searchCount.reportType.name}-${searchCount.periodType.name}':
          searchCount.count,
    'users': users
        .map((user) => ActiveUserModel.fromEntity(user).toJson())
        .toList(),
  };

  MonthlyAnalyticsEntity toEntity() => MonthlyAnalyticsEntity(
    searchCounts: searchCounts,
    users: users,
    enterprise: enterprise,
  );
}
