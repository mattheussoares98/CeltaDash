import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/operators/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operators_controller.g.dart';

@riverpod
class OperatorsController extends _$OperatorsController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    int enterpriseId,
    OperatorsPeriod selectedPeriod,
  ) async {
    ref.cache(10);
    ref.watch(activeEcParamsStateControllerProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        CategoryGroupingType.cashierOperator,
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
    required OperatorsPeriod selectedPeriod,
  }) {
    switch (selectedPeriod) {
      case OperatorsPeriod.daily:
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
          groupByCashierOperator: true,
          groupByDay: true,
        );
      case OperatorsPeriod.monthly:
        final startDate = DateTime(selectedDate.year, selectedDate.month);
        final endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByMonth: true,
        );
      case OperatorsPeriod.yearly:
        final startDate = DateTime(selectedDate.year);
        final endDate = DateTime(selectedDate.year, 12, 31);
        return GetSaleStatisticsParams(
          enterpriseIds: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByYear: true,
        );
    }
  }
}
