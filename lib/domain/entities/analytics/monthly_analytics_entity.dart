import 'package:equatable/equatable.dart';

import '../entities.dart';

class MonthlyAnalyticsEntity extends Equatable {
  final List<SearchCountEntity> searchCounts;
  final List<ActiveUserEntity> users;

  const MonthlyAnalyticsEntity({
    required this.searchCounts,
    required this.users,
  });

  @override
  List<Object?> get props => [searchCounts, users];
}
