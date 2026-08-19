// lib/features/sellers/presentation/controllers/sellers_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sellers/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sellers_controller.g.dart';

@riverpod
class SellersController extends _$SellersController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    int enterpriseId,
    SellersPeriod selectedPeriod,
  ) async {
    ref.cache();
    ref.watch(activeEcParamsStateControllerProvider);
    ref.watch(resumeCurrentDateProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        CategoryGroupingType.seller,
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
    required SellersPeriod selectedPeriod,
  }) {
    switch (selectedPeriod) {
      case SellersPeriod.daily:
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
          groupBySeller: true,
          groupByDay: true,
        );
      case SellersPeriod.monthly:
        final startDate = DateTime(selectedDate.year, selectedDate.month);
        final endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupBySeller: true,
          groupByMonth: true,
          groupByYear: true,
        );
      case SellersPeriod.yearly:
        final startDate = DateTime(selectedDate.year);
        final endDate = DateTime(selectedDate.year, 12, 31);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupBySeller: true,
          groupByYear: true,
        );
    }
  }
}
