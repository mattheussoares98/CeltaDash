import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/payments/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payments_controller.g.dart';

@riverpod
class PaymentsController extends _$PaymentsController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    PaymentsPeriod selectedPeriod,
  ) async {
    ref.cache(300);
    ref.watch(activeEcParamsStateControllerProvider);
    final homeSelection = await ref.watch(
      homeControllerProvider.selectAsync(
        (state) => (
          enterpriseId: state.selectedEnterpriseId,
          selectedDate: state.selectedDate,
        ),
      ),
    );
    final enterpriseId = homeSelection.enterpriseId;
    if (enterpriseId == null) {
      throw Exception('Nenhuma empresa selecionada.');
    }

    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        CategoryGroupingType.paymentModality,
        periodGroupingType: selectedPeriod.periodGroupingType,
      ).notifier,
    );
    final statisticsState = await statisticsController.loadStatistics(
      params: _buildParams(
        enterpriseId: enterpriseId,
        selectedDate: homeSelection.selectedDate,
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
  }) {
    final monthEnd = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedPeriod == PaymentsPeriod.daily ? selectedDate.day : 1,
    );

    return GetSaleStatisticsParams(
      enterpriseIds: [enterpriseId],
      startDate: startDate,
      endDate: selectedPeriod == PaymentsPeriod.daily ? startDate : monthEnd,
      groupByEnterprise: true,
      groupByDay: selectedPeriod == PaymentsPeriod.daily,
      groupByMonth: selectedPeriod == PaymentsPeriod.monthly,
      groupByYear: selectedPeriod == PaymentsPeriod.monthly,
      groupByPaymentModality: true,
      groupByPaymentFinalization: true,
    );
  }
}
