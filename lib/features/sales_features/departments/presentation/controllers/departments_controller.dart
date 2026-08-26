import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/departments/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'departments_controller.g.dart';

@riverpod
class DepartmentsController extends _$DepartmentsController {
  @override
  Future<List<SaleStatisticsEntity>> build(
    int enterpriseId,
    DepartmentsPeriod selectedPeriod,
  ) async {
    ref.cache();
    ref.watch(activeEcParamsStateControllerProvider);
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    final statisticsController = ref.watch(
      saleStatisticsControllerProvider(
        CategoryGroupingType.productDepartment,
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

    ref
        .read(appAnalyticsRepositoryProvider)
        .addNewMonthlyAnalytic(
          reportType: .departments,
          periodType: selectedPeriod == DepartmentsPeriod.daily
              ? .daily
              : .monthly,
        );

    return statisticsState.requireValue;
  }

  GetSaleStatisticsParams _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required DepartmentsPeriod selectedPeriod,
  }) {
    final monthEnd = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedPeriod == DepartmentsPeriod.daily ? selectedDate.day : 1,
    );

    return GetSaleStatisticsParams(
      enterpriseIds: [enterpriseId],
      startDate: startDate,
      endDate: selectedPeriod == DepartmentsPeriod.daily ? startDate : monthEnd,
      groupByEnterprise: true,
      groupByDay: selectedPeriod == DepartmentsPeriod.daily,
      groupByMonth: selectedPeriod == DepartmentsPeriod.monthly,
      groupByYear: selectedPeriod == DepartmentsPeriod.monthly,
      groupByProductDepartment: true,
      groupByProductSection: true,
    );
  }
}
