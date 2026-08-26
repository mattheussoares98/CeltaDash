// lib/features/app_analytics/domain/entities/app_analytics_user_entity.dart
import 'package:equatable/equatable.dart';

class AppAnalyticsUserEntity extends Equatable {
  final String userName;
  final String platform;

  const AppAnalyticsUserEntity({
    required this.userName,
    required this.platform,
  });

  AppAnalyticsUserEntity copyWith({String? userName, String? platform}) =>
      AppAnalyticsUserEntity(
        userName: userName ?? this.userName,
        platform: platform ?? this.platform,
      );

  @override
  List<Object?> get props => [userName, platform];
}
