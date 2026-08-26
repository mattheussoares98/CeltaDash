// lib/features/home/presentation/controllers/sales_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_sales_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeSalesController extends _$HomeSalesController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    int enterpriseId,
    HomeSalesPeriod selectedPeriod,
  ) async {
    ref.invalidatePeriodically();
    ref.watch(activeEcParamsStateControllerProvider);
    ref.watch(resumeCurrentDateProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        null,
        periodGroupingType: selectedPeriod.periodGroupingType,
      ).notifier,
    );
    final statisticsState = await statisticsController.loadStatistics(
      params: _buildParams(
        enterpriseId: enterpriseId,
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
          reportType: .sales,
          periodType: switch (selectedPeriod) {
            HomeSalesPeriod.hourly => .hourly,
            HomeSalesPeriod.daily => .daily,
            HomeSalesPeriod.monthly => .monthly,
            HomeSalesPeriod.yearly => .yearly,
          },
        );

    return statisticsState.requireValue;
  }

  GetSaleStatisticsParams _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required HomeSalesPeriod selectedPeriod,
  }) {
    switch (selectedPeriod) {
      case HomeSalesPeriod.hourly:
        final date = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: date,
          endDate: date,
          groupByEnterprise: true,
          groupByHour: true,
        );
      case HomeSalesPeriod.daily:
        final startDate = DateTime(selectedDate.year, selectedDate.month);
        final endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByDay: true,
        );
      case HomeSalesPeriod.monthly:
        final startDate = DateTime(selectedDate.year);
        final endDate = DateTime(selectedDate.year, 12, 31);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByMonth: true,
          groupByYear: true,
        );
      case HomeSalesPeriod.yearly:
        final startDate = DateTime(selectedDate.year - 2);
        final endDate = DateTime(selectedDate.year, 12, 31);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByYear: true,
        );
    }
  }
}
