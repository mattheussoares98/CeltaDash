import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/sales/daily_comparison_state.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_comparison_controller.g.dart';

@Riverpod(keepAlive: true)
class DailyComparisonController extends _$DailyComparisonController {
  @override
  Future<DailyComparisonState> build(int enterpriseId) async {
    ref.watch(activeEcParamsStateControllerProvider);

    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((selection) => selection.selectedDate),
    );
    final currentSelectedDate = ref.watch(resumeCurrentDateProvider);
    final isCurrentDay =
        selectedDate.year == currentSelectedDate.year &&
        selectedDate.month == currentSelectedDate.month &&
        selectedDate.day == currentSelectedDate.day;
    final comparisonDate = DateTime(
      selectedDate.year,
      selectedDate.month - 1,
      selectedDate.day,
    );
    final selectedParams = _makeParams(
      date: selectedDate,
      enterpriseId: enterpriseId,
      currentSelectedDate: currentSelectedDate,
      isCurrentDay: isCurrentDay,
    );
    final comparisonParams = _makeParams(
      date: comparisonDate,
      enterpriseId: enterpriseId,
      currentSelectedDate: currentSelectedDate,
      isCurrentDay: isCurrentDay,
    );
    final selectedProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .day,
    );
    final comparisonProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .day,
      seriesType: .comparison,
    );
    final selectedController = ref.watch(selectedProvider.notifier);
    final comparisonController = ref.watch(comparisonProvider.notifier);
    final statisticsStates = await Future.wait([
      selectedController.loadStatistics(
        params: selectedParams,
        forceRefresh: true,
      ),
      comparisonController.loadStatistics(
        params: comparisonParams,
        forceRefresh: true,
      ),
    ]);
    final selectedState = statisticsStates.first;
    final comparisonState = statisticsStates.last;
    if (selectedState.hasError) {
      Error.throwWithStackTrace(
        selectedState.error!,
        selectedState.stackTrace!,
      );
    }
    if (comparisonState.hasError) {
      Error.throwWithStackTrace(
        comparisonState.error!,
        comparisonState.stackTrace!,
      );
    }
    final results = [selectedState.requireValue, comparisonState.requireValue];

    return DailyComparisonState(
      selectedDate: isCurrentDay ? DateTime.now() : selectedDate,
      comparisonDate: comparisonDate,
      selectedLiquidValue: results.first.sumLiquidValue(),
      comparisonLiquidValue: results.last.sumLiquidValue(),
      selectedCustomers: results.first.sumCustomers(),
      comparisonCustomers: results.last.sumCustomers(),
    );
  }

  GetSaleStatisticsParams _makeParams({
    required DateTime date,
    required int enterpriseId,
    required DateTime currentSelectedDate,
    required bool isCurrentDay,
  }) => GetSaleStatisticsParams(
    startDate: DateTime(date.year, date.month, date.day),
    endDate: DateTime(
      date.year,
      date.month,
      date.day,
      isCurrentDay ? currentSelectedDate.hour : 23,
      isCurrentDay ? currentSelectedDate.minute : 59,
    ),
    groupByEnterprise: true,
    groupByDay: true,
    enterpriseIds: [enterpriseId],
  );
}
