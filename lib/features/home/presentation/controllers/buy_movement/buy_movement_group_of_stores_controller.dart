import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/buy_movement/presentation/models/models.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buy_movement_group_of_stores_controller.g.dart';

@Riverpod(keepAlive: true)
class BuyMovementGroupOfStoresController
    extends _$BuyMovementGroupOfStoresController {
  @override
  Future<BuyMovementGroupOfStoresState> build(int enterpriseId) async {
    ref.invalidatePeriodically();
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );
    final enterprises = await ref.watch(enterprisesControllerProvider.future);
    final enabledEnterprises = enterprises
        .where((enterprise) => enterprise.enabled && enterprise.id != null)
        .toList(growable: false);

    if (enabledEnterprises.length <= 1) {
      return const BuyMovementGroupOfStoresState(enterprises: []);
    }

    final date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final controller = ref.watch(
      buyMovementControllerProvider(
        BuyMovementQuerySlot.groupOfStores,
      ).notifier,
    );
    final movementState = await controller.loadData(
      params: SearchBuyMovementDataParamsEntity(
        enterpriseCodes: enabledEnterprises
            .map((enterprise) => enterprise.id!)
            .toList(growable: false),
        startDate: date,
        endDate: date,
        periodGrouping: BuyMovementPeriodGrouping.day,
        groupByEnterprise: true,
      ),
      forceRefresh: true,
    );

    if (movementState.hasError) {
      Error.throwWithStackTrace(
        movementState.error!,
        movementState.stackTrace!,
      );
    }

    ref
        .read(appAnalyticsRepositoryProvider)
        .addNewMonthlyAnalytic(
          reportType: .buyMovementGroupOfStores,
          periodType: .daily,
        );

    final groupedRows = groupBy(
      movementState.requireValue.results,
      (BuyMovementDataRowEntity row) => row.enterpriseCode,
    );
    final result = enabledEnterprises.map((enterprise) {
      final totalValue = (groupedRows[enterprise.id] ?? const [])
          .fold<num>(0, (total, row) => total + row.totalValue)
          .toDouble();
      final code = enterprise.personalizedCode?.trim();
      final name = enterprise.name?.trim();
      return BuyMovementGroupOfStoresEnterpriseState(
        id: enterprise.id!,
        name: [
          if (code?.isNotEmpty ?? false) code!,
          if (name?.isNotEmpty ?? false) name!,
        ].join('-'),
        totalValue: totalValue,
      );
    }).toList()..sort((a, b) => b.totalValue.compareTo(a.totalValue));

    return BuyMovementGroupOfStoresState(enterprises: result);
  }
}
