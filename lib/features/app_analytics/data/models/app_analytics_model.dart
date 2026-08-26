// lib/features/app_analytics/data/models/app_analytics_model.dart
import 'package:celta_dash/features/app_analytics/data/models/models.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';

class AppAnalyticsModel {
  final List<AppAnalyticsSearchCountModel> searchCounts;
  final List<AppAnalyticsUserModel> users;
  final String enterprise;

  const AppAnalyticsModel({
    required this.searchCounts,
    required this.users,
    required this.enterprise,
  });

  factory AppAnalyticsModel.fromJson(Map json, {required String enterpriseId}) {
    final searchCounts = <AppAnalyticsSearchCountModel>[];
    final users = <AppAnalyticsUserModel>[];

    for (final MapEntry(:key, :value) in json.entries) {
      if (key == 'users' && value is List) {
        users.addAll(
          value.whereType<Map>().map(AppAnalyticsUserModel.fromJson),
        );
        continue;
      }

      final parts = key.toString().split('-');
      if (parts.length != 2 || value is! int) continue;

      final reportType = AppAnalyticsReportType.values
          .where((type) => type.name == parts.first)
          .firstOrNull;
      final periodType = AppAnalyticsPeriodType.values
          .where((type) => type.name == parts.last)
          .firstOrNull;
      if (reportType == null || periodType == null) continue;

      searchCounts.add(
        AppAnalyticsSearchCountModel(
          reportType: reportType,
          periodType: periodType,
          count: value,
        ),
      );
    }

    return AppAnalyticsModel(
      searchCounts: searchCounts,
      users: users,
      enterprise: enterpriseId,
    );
  }

  factory AppAnalyticsModel.fromEntity(AppAnalyticsEntity entity) =>
      AppAnalyticsModel(
        searchCounts: entity.searchCounts
            .map(AppAnalyticsSearchCountModel.fromEntity)
            .toList(growable: false),
        users: entity.users
            .map(AppAnalyticsUserModel.fromEntity)
            .toList(growable: false),
        enterprise: entity.enterprise,
      );

  Map toJson() => {
    for (final searchCount in searchCounts)
      '${searchCount.reportType.name}-${searchCount.periodType.name}':
          searchCount.count,
    'users': users.map((user) => user.toJson()).toList(),
  };

  AppAnalyticsEntity toEntity() => AppAnalyticsEntity(
    searchCounts: searchCounts
        .map((searchCount) => searchCount.toEntity())
        .toList(growable: false),
    users: users.map((user) => user.toEntity()).toList(growable: false),
    enterprise: enterprise,
  );
}
