// lib/features/home/presentation/controllers/home_financial_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_financial_controller.g.dart';

@riverpod
class HomeFinancialController extends _$HomeFinancialController {
  @override
  Future<FinancialTitleDataResponseEntity> build(
    int enterpriseId,
    HomeFinancialPeriod selectedPeriod,
  ) async {
    ref.cache();
    ref.watch(activeEcParamsStateControllerProvider);
    ref.watch(resumeCurrentDateProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    final financialController = ref.watch(
      financialTitlesControllerProvider(
        periodGrouping: selectedPeriod.periodGrouping,
      ).notifier,
    );
    final financialState = await financialController.loadData(
      params: _buildParams(
        enterpriseId: enterpriseId,
        selectedDate: selectedDate,
        selectedPeriod: selectedPeriod,
      ),
      forceRefresh: true,
    );

    if (financialState.hasError) {
      Error.throwWithStackTrace(
        financialState.error!,
        financialState.stackTrace!,
      );
    }

    return financialState.requireValue;
  }

  SearchFinancialTitleDataParams _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required HomeFinancialPeriod selectedPeriod,
  }) {
    switch (selectedPeriod) {
      case HomeFinancialPeriod.daily:
        final startDate = DateTime(selectedDate.year, selectedDate.month);
        final endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        return SearchFinancialTitleDataParams(
          enterpriseCodes: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          periodGrouping: FinancialTitlePeriodGrouping.day,
        );
      case HomeFinancialPeriod.monthly:
        final startDate = DateTime(selectedDate.year);
        final endDate = DateTime(selectedDate.year, 12, 31);
        return SearchFinancialTitleDataParams(
          enterpriseCodes: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          periodGrouping: FinancialTitlePeriodGrouping.month,
        );
      // case HomeFinancialPeriod.yearly:
      //   final startDate = DateTime(selectedDate.year - 2);
      //   final endDate = DateTime(selectedDate.year, 12, 31);
      //   return SearchFinancialTitleDataParams(
      //     enterpriseCodes: [enterpriseId],
      //     startDate: startDate,
      //     endDate: endDate,
      //     periodGrouping: FinancialTitlePeriodGrouping.year,
      //   );
    }
  }
}
