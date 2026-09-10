import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/buy_movement/presentation/models/models.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_buy_movement_products_controller.g.dart';

@riverpod
class HomeBuyMovementProductsController
    extends _$HomeBuyMovementProductsController {
  @override
  Future<List<BuyMovementDataRowEntity>> build(
    int enterpriseId,
    HomeBuyMovementPeriod selectedPeriod,
  ) async {
    ref.invalidatePeriodically();
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );
    final filters = ref.watch(homeBuyMovementProductsFilterControllerProvider);
    final controller = ref.watch(
      buyMovementControllerProvider(BuyMovementQuerySlot.products).notifier,
    );
    final movementState = await controller.loadData(
      params: _buildParams(
        enterpriseId: enterpriseId,
        selectedDate: selectedDate,
        selectedPeriod: selectedPeriod,
        filters: filters,
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
          reportType: .buyMovementProducts,
          periodType: switch (selectedPeriod) {
            HomeBuyMovementPeriod.hourly => .hourly,
            HomeBuyMovementPeriod.daily => .daily,
            HomeBuyMovementPeriod.monthly => .monthly,
            HomeBuyMovementPeriod.yearly => .yearly,
          },
        );

    return List.unmodifiable(movementState.requireValue.results);
  }

  SearchBuyMovementDataParamsEntity _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required HomeBuyMovementPeriod selectedPeriod,
    required HomeBuyMovementProductsFilterState filters,
  }) {
    final (startDate, endDate) = _dateRange(selectedDate, selectedPeriod);
    return SearchBuyMovementDataParamsEntity(
      enterpriseCodes: [enterpriseId],
      startDate: startDate,
      endDate: endDate,
      groupByProduct: true,
      productName: filters.productName,
      topCount: filters.topCount,
    );
  }

  (DateTime, DateTime) _dateRange(
    DateTime selectedDate,
    HomeBuyMovementPeriod selectedPeriod,
  ) {
    return switch (selectedPeriod) {
      HomeBuyMovementPeriod.hourly => (
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      ),
      HomeBuyMovementPeriod.daily => (
        DateTime(selectedDate.year, selectedDate.month),
        DateTime(selectedDate.year, selectedDate.month + 1, 0),
      ),
      HomeBuyMovementPeriod.monthly => (
        DateTime(selectedDate.year),
        DateTime(selectedDate.year, 12, 31),
      ),
      HomeBuyMovementPeriod.yearly => (
        DateTime(selectedDate.year - 2),
        DateTime(selectedDate.year, 12, 31),
      ),
    };
  }
}
