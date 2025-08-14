import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxCompareMonthsPresenter extends GetxController
    with ErrorHandling, UIErrorManager, LoadingManager
    implements CompareMonthsPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxCompareMonthsPresenter({
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();
  final homePresenter = Get.find<HomePresenter>();

  @override
  Future<void> getSales({
    required DateTime now,
    DateTime? selectedDate,
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      bool changedEnterprise = SearchHelper.changedTheEnterprise(
        selectedPeriodType: PeriodType.monthly,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastGetStatisticsParams: _lastParams,
      );

      //TODO add a local selected date to control the date
      if (changedEnterprise || _mergedSales.value.isEmpty) {
        //...continue
      } else if (forceRefresh != true) {
        return;
      }

      final selectedDateIsToday = selectedDate == null ||
          selectedDate.year == now.year &&
              selectedDate.month == now.month &&
              selectedDate.day == now.day;
      final dateToUse = selectedDate ?? now;

      final selectedMonthParams = GetSaleStatisticsParams(
        groupByDay: true,
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(
          dateToUse.year,
          dateToUse.month,
          1,
          selectedDateIsToday ? now.hour : 0,
        ),
        endDate: DateTime(
          dateToUse.year,
          dateToUse.month + 1,
          0,
          selectedDateIsToday ? now.hour : 0,
        ),
      );

      final selectedMonthRemote =
          await loadSaleStatistics.get(selectedMonthParams);

      final previousMonthParams = GetSaleStatisticsParams(
        groupByDay: true,
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(
          dateToUse.year,
          dateToUse.month - 1,
          1,
          selectedDateIsToday ? now.hour : 0,
        ),
        endDate: DateTime(
          dateToUse.year,
          dateToUse.month,
          0,
          selectedDateIsToday ? now.hour : 0,
        ),
      );
      final previousMonthRemote =
          await loadSaleStatistics.get(previousMonthParams);

      final previousYearParams = GetSaleStatisticsParams(
        groupByDay: true,
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(
          dateToUse.year - 1,
          dateToUse.month,
          1,
          selectedDateIsToday ? now.hour : 0,
        ),
        endDate: DateTime(
          dateToUse.year - 1,
          dateToUse.month + 1,
          0,
          selectedDateIsToday ? now.hour : 0,
        ),
      );
      final previousYearRemote = await loadSaleStatistics.get(
        previousYearParams,
      );

      final selectedMonth = selectedMonthRemote
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      final previousMonth = previousMonthRemote
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      final previousYear = previousYearRemote
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      _mergedSales.value = {
        if (selectedMonth.isNotEmpty)
          CompareMonthsPeriod.selectedMonth: selectedMonth,
        if (previousMonth.isNotEmpty)
          CompareMonthsPeriod.previousMonth: previousMonth,
        if (previousYear.isNotEmpty)
          CompareMonthsPeriod.previousYear: previousYear
      };

      _lastParams = selectedMonthParams;

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.compareMonths,
        periodType: PeriodType.monthly,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  final _mergedSales =
      Rx<Map<CompareMonthsPeriod, List<SaleStatisticViewModel>>>({});
  @override
  Map<CompareMonthsPeriod, List<SaleStatisticViewModel>> get mergedSales =>
      _mergedSales.value;

  @override
  GetSaleStatisticsParams? get lastParams => _lastParams;
  GetSaleStatisticsParams? _lastParams;
}
