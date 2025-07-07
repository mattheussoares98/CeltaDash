import '../../../domain/entities/entities.dart';
import 'app_analytics.dart';

class MonthlyAnalyticsModel extends MonthlyAnalyticsEntity {
  const MonthlyAnalyticsModel({
    required super.searchCounts,
    required super.users,
  });

  factory MonthlyAnalyticsModel.fromJson(Map<String, dynamic> json) {
    final searchCountsList = (json['searchCounts'] as List)
        .map((countJson) => SearchCountModel.fromJson(countJson))
        .toList();

    final usersList = (json['users'] as List)
        .map((userJson) => ActiveUserModel.fromJson(userJson))
        .toList();

    return MonthlyAnalyticsModel(
      searchCounts: searchCountsList,
      users: usersList,
    );
  }

  Map<String, dynamic> toJson() => {
        'searchCounts': searchCounts
            .map((searchCount) => SearchCountModel(
                    reportType: searchCount.reportType,
                    reportPeriod: searchCount.reportPeriod,
                    count: searchCount.count)
                .toJson())
            .toList(),
        'users': users
            .map((user) => ActiveUserModel(
                  userName: user.userName,
                  platform: user.platform,
                  lastActive: user.lastActive,
                ).toJson())
            .toList(),
      };

  MonthlyAnalyticsEntity toEntity() => MonthlyAnalyticsEntity(
        searchCounts: searchCounts,
        users: users,
      );
}
