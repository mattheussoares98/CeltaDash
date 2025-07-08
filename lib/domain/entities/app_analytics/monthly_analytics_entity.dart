import 'package:equatable/equatable.dart';

import '../entities.dart';

class MonthlyAnalyticsEntity extends Equatable {
  final List<SearchCountEntity> searchCounts;
  final List<ActiveUserEntity> users;
  final String enterprise;

  const MonthlyAnalyticsEntity({
    required this.searchCounts,
    required this.users,
    required this.enterprise,
  });

  @override
  List<Object?> get props => [searchCounts, users, enterprise];
}
