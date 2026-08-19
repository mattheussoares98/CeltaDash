import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/presentation/controllers/daily_comparison_controller.dart';
import 'package:celta_dash/features/home/presentation/controllers/home_data_selection_controller.dart';
import 'package:celta_dash/features/home/presentation/models/monthly_goal_comparison_state.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_goal_comparison_controller.g.dart';

@Riverpod(keepAlive: true)
class MonthlyGoalComparisonController
    extends _$MonthlyGoalComparisonController {
  @override
  Future<MonthlyGoalComparisonState> build(int enterpriseId) async {
    ref.watch(activeEcParamsStateControllerProvider);

    final selectedDate = await ref.watch(
      homeDataSelectionControllerProvider(
        AppMode.sales,
      ).selectAsync((selection) => selection?.selectedDate),
    );
    if (selectedDate == null) return state.requireValue;

    final dailyComparisonSelectedLiquidValue = ref.watch(
      dailyComparisonControllerProvider(
        enterpriseId,
      ).selectAsync((s) => s.selectedLiquidValue),
    );

    final currentMonthParams = GetSaleStatisticsParams(
      startDate: DateTime(selectedDate.year, selectedDate.month),
      endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
      groupByEnterprise: true,
      groupByYear: true,
      groupByMonth: true,
      enterpriseIds: [enterpriseId],
    );
    var comparisonParams = currentMonthParams.copyWith(
      startDate: DateTime(selectedDate.year - 1, selectedDate.month),
      endDate: DateTime(selectedDate.year - 1, selectedDate.month + 1, 0),
    );
    final currentMonthProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .month,
    );
    final comparisonProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .month,
      seriesType: .comparison,
    );
    final currentMonthController = ref.watch(currentMonthProvider.notifier);
    final comparisonController = ref.watch(comparisonProvider.notifier);
    final initialStates = await Future.wait([
      currentMonthController.loadStatistics(
        params: currentMonthParams,
        forceRefresh: true,
      ),
      comparisonController.loadStatistics(
        params: comparisonParams,
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
    final currentMonthStatistics = initialStates.first.requireValue;
    var comparisonStatistics = initialStates.last.requireValue;

    if (comparisonStatistics.isEmpty) {
      comparisonParams = currentMonthParams.copyWith(
        startDate: DateTime(selectedDate.year, selectedDate.month - 1),
        endDate: DateTime(selectedDate.year, selectedDate.month, 0),
      );
      comparisonStatistics = (await comparisonController.loadStatistics(
        params: comparisonParams,
        forceRefresh: true,
      )).requireValue;
    }

    return MonthlyGoalComparisonState(
      selectedDate: selectedDate,
      comparisonDate: comparisonParams.endDate,
      currentMonthLiquidValue: currentMonthStatistics.sumLiquidValue(),
      comparisonLiquidValue: comparisonStatistics.sumLiquidValue(),
      selectedDayLiquidValue: await dailyComparisonSelectedLiquidValue,
    );
  }
}
