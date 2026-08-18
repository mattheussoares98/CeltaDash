// lib/features/home/presentation/controllers/sales_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_controller.g.dart';

@riverpod
class SalesController extends _$SalesController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    int enterpriseId,
    SalesPeriod selectedPeriod,
  ) async {
    ref.cache(300);
    ref.watch(activeEcParamsStateControllerProvider);
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

    return statisticsState.requireValue;
  }

  GetSaleStatisticsParams _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required SalesPeriod selectedPeriod,
  }) {
    switch (selectedPeriod) {
      case SalesPeriod.hourly:
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
      case SalesPeriod.daily:
        final startDate = DateTime(selectedDate.year, selectedDate.month);
        final endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByDay: true,
        );
      case SalesPeriod.monthly:
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
      case SalesPeriod.yearly:
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
