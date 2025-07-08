import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxResumePresenter extends GetxController
    with
        ErrorHandling,
        SaleStatisticsManager,
        UIErrorManager,
        LoadingManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements ResumePresenter {
  final NavigateTo navigateTo;
  final LoadSaleStatistics loadSaleStatistics;

  GetxResumePresenter({
    required this.navigateTo,
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();

  @override
  void goToSetGoalPage() {
    navigateTo.navigate(pageRoute: PageRoutes.setGoal);
  }

  @override
  void goToGoalHistoryPage() {
    navigateTo.navigate(pageRoute: PageRoutes.goalHistory);
  }

  @override
  void goToGroupSummaryPage() {
    navigateTo.navigate(pageRoute: PageRoutes.groupSummary);
  }

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    required DateTime now,
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
      return;
    }

    isLoading = true;
    mainError = null;
    try {
      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = SearchHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: lastGetStatisticsParams,
        selectedDate: homePresenter.selectedDate,
        periodType: PeriodType.monthly,
      );

      final changedEnterprise = SearchHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriod,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastGetStatisticsParams: lastGetComparisonParams,
      );

      if (changedEnterprise ||
          canSearchAgain ||
          homePresenter.selectedDate.day !=
              lastGetComparisonParams?.startDate.day) {
        await _getCompareDaysStatistics(homePresenter, now);
      }
      if (!canSearchAgain) {
        return;
      }

      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        1,
      );
      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        1,
      ).subtract(Duration(days: 1));

      final salesParams = GetSaleStatisticsParams(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByDay: true,
      );
      final result = await loadSaleStatistics.get(salesParams);

      saleStatistics = result
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      lastParams = salesParams;

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.resume,
        periodType: PeriodType.monthly,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> _getCompareDaysStatistics(
    HomePresenter homePresenter,
    DateTime now,
  ) async {
    final isCurrentDay = homePresenter.selectedDate.day == now.day &&
        homePresenter.selectedDate.month == now.month &&
        homePresenter.selectedDate.year == now.year;

    final todayParams = GetSaleStatisticsParams(
      startDate: DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        homePresenter.selectedDate.day,
      ),
      endDate: DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        homePresenter.selectedDate.day,
        isCurrentDay ? now.hour : 23,
        isCurrentDay ? now.minute : 59,
      ),
      groupByEnterprise: true,
      groupByDay: true,
      enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
    );
    final todaySaleStatistics = await loadSaleStatistics.get(todayParams);

    final lastMonthSaleStatistics = await loadSaleStatistics.get(
      GetSaleStatisticsParams(
        startDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month - 1,
          homePresenter.selectedDate.day,
        ),
        endDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month - 1,
          homePresenter.selectedDate.day,
          isCurrentDay ? now.hour : 23,
          isCurrentDay ? now.minute : 59,
        ),
        groupByEnterprise: true,
        groupByDay: true,
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
      ),
    );

    lastGetComparisonParams = todayParams;

    _compareDaysStatistics.value = [
      ...todaySaleStatistics
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
      ...lastMonthSaleStatistics
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
    ];
  }

  final _compareDaysStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get compareDaysStatistics =>
      _compareDaysStatistics.value;
  set compareDaysStatistics(List<SaleStatisticViewModel>? value) =>
      _compareDaysStatistics.value = value;
}
