import 'package:celta_dash/features/web_enterprises/domain/domain.dart';

class WebAnalyticsUserModel {
  final String userName;
  final String platform;

  const WebAnalyticsUserModel({required this.userName, required this.platform});

  factory WebAnalyticsUserModel.fromJson(Map json) => WebAnalyticsUserModel(
    userName: json['userName'] as String? ?? '',
    platform: json['platform'] as String? ?? '',
  );

  factory WebAnalyticsUserModel.fromEntity(WebAnalyticsUserEntity entity) =>
      WebAnalyticsUserModel(
        userName: entity.userName,
        platform: entity.platform,
      );

  Map toJson() => {'userName': userName, 'platform': platform};

  WebAnalyticsUserEntity toEntity() =>
      WebAnalyticsUserEntity(userName: userName, platform: platform);
}
