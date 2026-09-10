import 'package:celta_dash/core/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/buy_movement/presentation/models/models.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_buy_movement_controller.g.dart';

@riverpod
class HomeBuyMovementController extends _$HomeBuyMovementController {
  @override
  Future<HomeBuyMovementState> build(
    int enterpriseId,
    HomeBuyMovementPeriod selectedPeriod,
  ) async {
    ref.cache();
    ref.watch(activeEcParamsStateControllerProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );
    final controller = ref.watch(
      buyMovementControllerProvider(_querySlot(selectedPeriod)).notifier,
    );
    final movementState = await controller.loadData(
      params: _buildParams(
        enterpriseId: enterpriseId,
        selectedDate: selectedDate,
        selectedPeriod: selectedPeriod,
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
          reportType: .buyMovements,
          periodType: switch (selectedPeriod) {
            HomeBuyMovementPeriod.hourly => .hourly,
            HomeBuyMovementPeriod.daily => .daily,
            HomeBuyMovementPeriod.monthly => .monthly,
            HomeBuyMovementPeriod.yearly => .yearly,
          },
        );

    return HomeBuyMovementState.fromRows(movementState.requireValue.results);
  }

  SearchBuyMovementDataParamsEntity _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required HomeBuyMovementPeriod selectedPeriod,
  }) {
    final (startDate, endDate) = _dateRange(selectedDate, selectedPeriod);
    return SearchBuyMovementDataParamsEntity(
      enterpriseCodes: [enterpriseId],
      startDate: startDate,
      endDate: endDate,
      periodGrouping: selectedPeriod.periodGrouping,
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

  BuyMovementQuerySlot _querySlot(HomeBuyMovementPeriod selectedPeriod) {
    return switch (selectedPeriod) {
      HomeBuyMovementPeriod.hourly => BuyMovementQuerySlot.hourly,
      HomeBuyMovementPeriod.daily => BuyMovementQuerySlot.daily,
      HomeBuyMovementPeriod.monthly => BuyMovementQuerySlot.monthly,
      HomeBuyMovementPeriod.yearly => BuyMovementQuerySlot.yearly,
    };
  }
}
