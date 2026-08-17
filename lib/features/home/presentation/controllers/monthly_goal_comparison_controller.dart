import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_goal_comparison_controller.g.dart';

@riverpod
class MonthlyGoalComparisonController
    extends _$MonthlyGoalComparisonController {
  @override
  Future<MonthlyGoalComparisonState> build(int enterpriseId) async {
    ref.cache(300);
    //TODO test changing the logged enterprise to check whether will reload or not

    final selectedDate = (await ref.watch(
      homeControllerProvider.selectAsync((s) => s.selectedDate),
    ));

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
      currentMonthController.loadStatistics(params: currentMonthParams),
      comparisonController.loadStatistics(params: comparisonParams),
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
