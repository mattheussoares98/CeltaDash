// lib/features/group_summary/presentation/controllers/group_summary_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/group_summary/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_summary_controller.g.dart';

@riverpod
class GroupSummaryController extends _$GroupSummaryController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    int enterpriseId,
    GroupSummaryPeriod selectedPeriod,
  ) async {
    ref.cache();
    ref.watch(activeEcParamsStateControllerProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        null,
        periodGroupingType: selectedPeriod.periodGroupingType,
        seriesType: SaleStatisticsSeriesType.groupOfStores,
      ).notifier,
    );
    final statisticsState = await statisticsController.loadStatistics(
      params: _buildParams(
        selectedDate: selectedDate,
        selectedPeriod: selectedPeriod,
      ),
      forceRefresh: true,
    );

    if (statisticsState.hasError) {
      Error.throwWithStackTrace(
        statisticsState.error!,
        statisticsState.stackTrace!,
      );
    }

    ref
        .read(appAnalyticsRepositoryProvider)
        .addNewMonthlyAnalytic(
          reportType: .groupSummary,
          periodType: selectedPeriod == GroupSummaryPeriod.daily
              ? .daily
              : .monthly,
        );

    return statisticsState.requireValue;
  }

  GetSaleStatisticsParams _buildParams({
    required DateTime selectedDate,
    required GroupSummaryPeriod selectedPeriod,
  }) {
    final isDaily = selectedPeriod == GroupSummaryPeriod.daily;
    final monthEnd = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      isDaily ? selectedDate.day : 1,
    );

    return GetSaleStatisticsParams(
      startDate: startDate,
      endDate: isDaily ? startDate : monthEnd,
      groupByEnterprise: true,
      groupByDay: isDaily,
      groupByMonth: !isDaily,
      groupByYear: !isDaily,
    );
  }
}
