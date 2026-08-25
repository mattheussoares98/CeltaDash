// lib/features/home/presentation/controllers/financial/financial_group_of_stores_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_group_of_stores_controller.g.dart';

@Riverpod(keepAlive: true)
class FinancialGroupOfStoresController
    extends _$FinancialGroupOfStoresController {
  @override
  Future<FinancialGroupOfStoresState> build(int enterpriseId) async {
    ref.watch(activeEcParamsStateControllerProvider);
    final periodType = ref.watch(homeFinancialPeriodTypeControllerProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((s) => s.selectedDate),
    );
    final enterprises = await ref.watch(enterprisesControllerProvider.future);
    final enabledEnterprises = enterprises
        .where((e) => e.enabled && e.id != null)
        .toList();

    if (enabledEnterprises.length <= 1) {
      return const FinancialGroupOfStoresState(enterprises: []);
    }

    final enterpriseCodes = enabledEnterprises.map((e) => e.id!).toList();
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final endDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
      59,
    );

    final params = SearchFinancialTitleDataParams(
      enterpriseCodes: enterpriseCodes,
      startDate: startDate,
      endDate: endDate,
      periodGrouping: FinancialTitlePeriodGrouping.day,
      periodType: periodType,
      groupByEnterprise: true,
    );

    final financialController = ref.watch(
      financialTitlesControllerProvider(
        periodGrouping: FinancialTitlePeriodGrouping.day,
        periodType: periodType,
      ).notifier,
    );
    final financialState = await financialController.loadData(
      params: params,
      forceRefresh: true,
    );

    if (financialState.hasError) {
      Error.throwWithStackTrace(
        financialState.error!,
        financialState.stackTrace!,
      );
    }

    final portions = financialState.requireValue.financialTitlePortions;
    final grouped = groupBy(
      portions,
      (FinancialTitleDataRowEntity p) => p.enterpriseCode,
    );

    final resultEnterprises =
        enabledEnterprises.map((enterprise) {
          final portionsForEnt = grouped[enterprise.id] ?? [];
          final receive = portionsForEnt.fold<double>(
            0,
            (sum, p) => sum + (p.receiveLiquidValue?.toDouble() ?? 0),
          );
          final pay = portionsForEnt.fold<double>(
            0,
            (sum, p) => sum + (p.payLiquidValue?.toDouble() ?? 0),
          );
          return FinancialGroupOfStoresEnterpriseState(
            id: enterprise.id,
            name: enterprise.name ?? '',
            receiveLiquidValue: receive,
            payLiquidValue: pay,
          );
        }).toList()..sort(
          (a, b) => (b.receiveLiquidValue + b.payLiquidValue).compareTo(
            a.receiveLiquidValue + a.payLiquidValue,
          ),
        );

    return FinancialGroupOfStoresState(enterprises: resultEnterprises);
  }
}
