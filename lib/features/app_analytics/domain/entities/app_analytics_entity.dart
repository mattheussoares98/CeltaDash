// lib/features/app_analytics/domain/entities/app_analytics_entity.dart
import 'package:celta_dash/features/app_analytics/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class AppAnalyticsEntity extends Equatable {
  final List<AppAnalyticsSearchCountEntity> searchCounts;
  final List<AppAnalyticsUserEntity> users;
  final String enterprise;

  const AppAnalyticsEntity({
    required this.searchCounts,
    required this.users,
    required this.enterprise,
  });

  AppAnalyticsEntity copyWith({
    List<AppAnalyticsSearchCountEntity>? searchCounts,
    List<AppAnalyticsUserEntity>? users,
    String? enterprise,
  }) => AppAnalyticsEntity(
    searchCounts: searchCounts ?? this.searchCounts,
    users: users ?? this.users,
    enterprise: enterprise ?? this.enterprise,
  );

  @override
  List<Object?> get props => [searchCounts, users, enterprise];
}
