import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/entities.dart';
import 'view_models.dart';

class MonthlyAnalyticsViewModel extends Equatable {
  final String enterprise;
  final List<SearchCountViewModel> searchCounts;
  final List<ActiveUserViewModel> users;
  final String totalSearchesFormatted;
  final int uniqueUserCount;

  const MonthlyAnalyticsViewModel({
    required this.enterprise,
    required this.searchCounts,
    required this.users,
    required this.totalSearchesFormatted,
    required this.uniqueUserCount,
  });

  factory MonthlyAnalyticsViewModel.fromEntity(MonthlyAnalyticsEntity entity) {
    final searchCountViewModels = entity.searchCounts
        .map((e) => SearchCountViewModel.fromEntity(e))
        .toList();
    final userViewModels =
        entity.users.map((e) => ActiveUserViewModel.fromEntity(e)).toList();
    final totalSearches =
        entity.searchCounts.fold<int>(0, (sum, item) => sum + item.count);

    return MonthlyAnalyticsViewModel(
      enterprise: entity.enterprise,
      searchCounts: searchCountViewModels,
      users: userViewModels,
      totalSearchesFormatted: NumberFormat.compact().format(totalSearches),
      uniqueUserCount: entity.users.length,
    );
  }

  @override
  List<Object?> get props => [
        enterprise,
        searchCounts,
        users,
        totalSearchesFormatted,
        uniqueUserCount
      ];
}
