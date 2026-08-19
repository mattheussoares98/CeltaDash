import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/presentation/controllers/home_data_selection_controller.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_of_stores_controller.g.dart';

@Riverpod(keepAlive: true)
class GroupOfStoresController extends _$GroupOfStoresController {
  @override
  Future<GroupOfStoresState> build(int enterpriseId) async {
    ref.watch(activeEcParamsStateControllerProvider);

    final selectedDate = await ref.watch(
      homeDataSelectionControllerProvider(
        AppMode.sales,
      ).selectAsync((s) => s?.selectedDate),
    );
    if (selectedDate == null) return state.requireValue;

    final params = GetSaleStatisticsParams(
      startDate: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ),
      endDate: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        23,
        59,
        59,
      ),
      groupByEnterprise: true,
      groupByDay: true,
    );
    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        null,
        periodGroupingType: .day,
        seriesType: .groupOfStores,
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

    final grouped = groupBy(
      statisticsState.requireValue,
      (statistic) => statistic.EnterpriseId,
    );

    final enterprises = grouped.entries.map((entry) {
      final first = entry.value.first;
      final code = first.EnterprisePersonalizedCode?.trim();
      final fantasyName = first.EnterpriseFantasyName?.trim();
      final name = [
        if (code?.isNotEmpty ?? false) code!,
        if (fantasyName?.isNotEmpty ?? false) fantasyName!,
      ].join('-');
      return GroupOfStoresEnterpriseState(
        id: entry.key,
        name: name,
        liquidValue: entry.value.sumLiquidValue().toDouble(),
      );
    }).toList()..sort((a, b) => b.liquidValue.compareTo(a.liquidValue));

    return GroupOfStoresState(enterprises: enterprises);
  }
}
