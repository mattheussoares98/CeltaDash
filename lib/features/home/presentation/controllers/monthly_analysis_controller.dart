import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_analysis_controller.g.dart';

@Riverpod(keepAlive: true)
class MonthlyAnalysisController extends _$MonthlyAnalysisController {
  @override
  Future<MonthlyAnalysisState> build(int enterpriseId) async {
    ref.watch(activeEcParamsStateControllerProvider);

    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((selection) => selection.selectedDate),
    );
    final now = ref.watch(resumeCurrentDateProvider);
    final isToday = _isSameDay(selectedDate, now);
    final params = GetSaleStatisticsParams(
      startDate: DateTime(selectedDate.year, selectedDate.month),
      endDate: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        isToday ? now.hour : 23,
        isToday ? now.minute : 59,
      ),
      groupByEnterprise: true,
      groupByDay: true,
      enterpriseIds: [enterpriseId],
    );
    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        null,
        periodGroupingType: .day,
        seriesType: .monthlyAnalysis,
      ).notifier,
    );
    final statisticsState = await statisticsController.loadStatistics(
      params: params,
      forceRefresh: true,
    );
    if (statisticsState.hasError) {
      Error.throwWithStackTrace(
        statisticsState.error!,
        statisticsState.stackTrace!,
      );
    }

    final statistics = statisticsState.requireValue;
    final dates =
        statistics
            .map((statistic) => statistic.Date)
            .whereType<DateTime>()
            .map((date) => DateTime(date.year, date.month, date.day))
            .toSet()
            .toList()
          ..sort();
    final visibleDates = dates.length > 2
        ? dates.where((date) => !_isSameDay(date, now))
        : dates;
    final days = visibleDates.map((date) {
      final value = statistics
          .where((statistic) => _isSameDay(statistic.Date, date))
          .sumLiquidValue();
      return MonthlyAnalysisDayState(date: date, value: value.toDouble());
    }).toList();

    return MonthlyAnalysisState(
      totalSales: statistics.sumLiquidValue(),
      days: days,
    );
  }

  bool _isSameDay(DateTime? first, DateTime second) =>
      first?.year == second.year &&
      first?.month == second.month &&
      first?.day == second.day;
}
