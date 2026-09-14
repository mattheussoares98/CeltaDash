import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/buy_movement/presentation/models/models.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_buy_movement_departments_controller.g.dart';

@riverpod
class HomeBuyMovementDepartmentsController
    extends _$HomeBuyMovementDepartmentsController {
  @override
  Future<List<BuyMovementDataRowEntity>> build(
    int enterpriseId,
    BuyMovementDepartmentsPeriod selectedPeriod,
  ) async {
    ref.cache();
    ref.invalidatePeriodically();
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );
    final controller = ref.watch(
      buyMovementControllerProvider(BuyMovementQuerySlot.departments).notifier,
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
          reportType: .buyMovementDepartments,
          periodType: switch (selectedPeriod) {
            .daily => .daily,
            .weekly => .weekly,
            .monthly => .monthly,
            .yearly => .yearly,
          },
        );

    return List.unmodifiable(movementState.requireValue.results);
  }

  SearchBuyMovementDataParamsEntity _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required BuyMovementDepartmentsPeriod selectedPeriod,
  }) {
    final (startDate, endDate) = _dateRange(selectedDate, selectedPeriod);
    return SearchBuyMovementDataParamsEntity(
      enterpriseCodes: [enterpriseId],
      startDate: startDate,
      endDate: endDate,
      groupByProductDepartment: true,
    );
  }

  (DateTime, DateTime) _dateRange(
    DateTime selectedDate,
    BuyMovementDepartmentsPeriod selectedPeriod,
  ) => switch (selectedPeriod) {
    BuyMovementDepartmentsPeriod.daily => (
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
    ),
    BuyMovementDepartmentsPeriod.weekly => (
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day - selectedDate.weekday + DateTime.monday,
      ),
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day - selectedDate.weekday + DateTime.sunday,
      ),
    ),
    BuyMovementDepartmentsPeriod.monthly => (
      DateTime(selectedDate.year, selectedDate.month),
      DateTime(selectedDate.year, selectedDate.month + 1, 0),
    ),
    BuyMovementDepartmentsPeriod.yearly => (
      DateTime(selectedDate.year),
      DateTime(selectedDate.year, 12, 31),
    ),
  };
}
