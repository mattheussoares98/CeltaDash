import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/goal_historic/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/goal_historic/presentation/models/models.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goal_historic_controller.g.dart';

@riverpod
class GoalHistoricController extends _$GoalHistoricController {
  @override
  Future<GoalHistoricState> build(int enterpriseId) async {
    ref.cache();
    ref.watch(activeEcParamsStateControllerProvider);
    final selectedYear = ref.watch(goalHistoricYearControllerProvider);
    final goals = await ref.watch(monthlyGoalsControllerProvider.future);

    final now = DateTime.now();
    final isCurrentYear = selectedYear == now.year;
    final endMonth = isCurrentYear ? now.month : 12;

    final selectedYearParams = GetSaleStatisticsParams(
      startDate: DateTime(selectedYear),
      endDate: DateTime(selectedYear, endMonth + 1, 0),
      groupByEnterprise: true,
      groupByYear: true,
      groupByMonth: true,
      enterpriseIds: [enterpriseId],
    );
    final previousYearParams = GetSaleStatisticsParams(
      startDate: DateTime(selectedYear - 1),
      endDate: DateTime(selectedYear - 1, endMonth + 1, 0),
      groupByEnterprise: true,
      groupByYear: true,
      groupByMonth: true,
      enterpriseIds: [enterpriseId],
    );

    final selectedYearProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .month,
    );
    final comparisonProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .month,
      seriesType: .comparison,
    );

    final selectedYearController = ref.watch(selectedYearProvider.notifier);
    final comparisonController = ref.watch(comparisonProvider.notifier);

    final initialStates = await Future.wait([
      selectedYearController.loadStatistics(
        params: selectedYearParams,
        forceRefresh: true,
      ),
      comparisonController.loadStatistics(
        params: previousYearParams,
        forceRefresh: true,
      ),
    ]);

    for (final statisticsState in initialStates) {
      if (statisticsState.hasError) {
        Error.throwWithStackTrace(
          statisticsState.error!,
          statisticsState.stackTrace!,
        );
      }
    }

    final currentYearStatistics = initialStates.first.requireValue;
    final previousYearStatistics = initialStates.last.requireValue;

    final rows = <GoalHistoricRowState>[];

    for (var month = 1; month <= endMonth; month++) {
      final currentSales = currentYearStatistics
          .where((e) => e.Month == month || e.Date?.month == month)
          .fold<double>(0.0, (acc, e) => acc + (e.LiquidValue ?? 0.0));

      final customGoal =
          goals[MonthlyGoalKey(
            enterpriseId: enterpriseId,
            year: selectedYear,
            month: month,
          )];

      final previousYearSales = previousYearStatistics
          .where((e) => e.Month == month || e.Date?.month == month)
          .fold<double>(0.0, (acc, e) => acc + (e.LiquidValue ?? 0.0));

      final double goalValue;
      final bool isCustom;
      final String? author;

      if (customGoal != null) {
        goalValue = customGoal.value;
        isCustom = true;
        author = customGoal.userName;
      } else if (previousYearSales > 0) {
        goalValue = previousYearSales * 1.05;
        isCustom = false;
        author = null;
      } else {
        goalValue = 0.0;
        isCustom = false;
        author = null;
      }

      if (currentSales > 0 || goalValue > 0) {
        rows.add(
          GoalHistoricRowState(
            year: selectedYear,
            month: month,
            goalValue: goalValue,
            salesValue: currentSales,
            isCustomGoal: isCustom,
            customGoalAuthor: author,
          ),
        );
      }
    }

    return GoalHistoricState(selectedYear: selectedYear, rows: rows);
  }
}
