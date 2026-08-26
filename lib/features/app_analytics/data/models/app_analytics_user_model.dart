// lib/features/app_analytics/data/models/app_analytics_user_model.dart
import 'package:celta_dash/features/app_analytics/domain/domain.dart';

class AppAnalyticsUserModel {
  final String userName;
  final String platform;

  const AppAnalyticsUserModel({required this.userName, required this.platform});

  factory AppAnalyticsUserModel.fromJson(Map json) => AppAnalyticsUserModel(
    userName: json['userName'] as String? ?? '',
    platform: json['platform'] as String? ?? '',
  );

  factory AppAnalyticsUserModel.fromEntity(AppAnalyticsUserEntity entity) =>
      AppAnalyticsUserModel(
        userName: entity.userName,
        platform: entity.platform,
      );

  Map toJson() => {'userName': userName, 'platform': platform};

  AppAnalyticsUserEntity toEntity() =>
      AppAnalyticsUserEntity(userName: userName, platform: platform);
}
