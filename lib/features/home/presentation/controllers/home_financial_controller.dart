// lib/features/home/presentation/controllers/home_financial_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_financial_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeFinancialController extends _$HomeFinancialController {
  @override
  Future<FinancialTitleDataResponseEntity> build(
    int enterpriseId,
    HomeFinancialPeriod selectedPeriod,
  ) async {
    ref.watch(activeEcParamsStateControllerProvider);
    final periodType = ref.watch(homeFinancialPeriodTypeControllerProvider);
    final initialSelectedDate = (await ref.read(
      homeControllerProvider.future,
    )).selectedDate;
    final selectedDate = ref.watch(
      homeControllerProvider.select(
        (state) => state.value?.selectedDate ?? initialSelectedDate,
      ),
    );

    final financialController = ref.watch(
      financialTitlesControllerProvider(
        periodGrouping: selectedPeriod.periodGrouping,
        periodType: periodType,
      ).notifier,
    );
    final financialState = await financialController.loadData(
      params: _buildParams(
        enterpriseId: enterpriseId,
        selectedDate: selectedDate,
        selectedPeriod: selectedPeriod,
        periodType: periodType,
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
    required FinancialTitlePeriodType periodType,
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
          periodType: periodType,
        );
      case HomeFinancialPeriod.monthly:
        final startDate = DateTime(selectedDate.year);
        final endDate = DateTime(selectedDate.year, 12, 31);
        return SearchFinancialTitleDataParams(
          enterpriseCodes: [enterpriseId],
          startDate: startDate,
          endDate: endDate,
          periodGrouping: FinancialTitlePeriodGrouping.month,
          periodType: periodType,
        );
      // case HomeFinancialPeriod.yearly:
      //   final startDate = DateTime(selectedDate.year - 2);
      //   final endDate = DateTime(selectedDate.year, 12, 31);
      //   return SearchFinancialTitleDataParams(
      //     enterpriseCodes: [enterpriseId],
      //     startDate: startDate,
      //     endDate: endDate,
      //     periodGrouping: FinancialTitlePeriodGrouping.year,
      //     periodType: periodType,
      //   );
    }
  }
}
