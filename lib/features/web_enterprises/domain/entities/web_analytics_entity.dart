import 'package:celta_dash/features/web_enterprises/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class WebAnalyticsEntity extends Equatable {
  final List<WebAnalyticsSearchCountEntity> searchCounts;
  final List<WebAnalyticsUserEntity> users;
  final String enterprise;

  const WebAnalyticsEntity({
    required this.searchCounts,
    required this.users,
    required this.enterprise,
  });

  WebAnalyticsEntity copyWith({
    List<WebAnalyticsSearchCountEntity>? searchCounts,
    List<WebAnalyticsUserEntity>? users,
    String? enterprise,
  }) => WebAnalyticsEntity(
    searchCounts: searchCounts ?? this.searchCounts,
    users: users ?? this.users,
    enterprise: enterprise ?? this.enterprise,
  );

  @override
  List<Object?> get props => [searchCounts, users, enterprise];
}
