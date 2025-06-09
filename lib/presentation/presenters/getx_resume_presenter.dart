import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxResumePresenter extends GetxController
    with
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

  @override
  void goToCompareDays() {
    navigateTo.navigate(pageRoute: PageRoutes.compareDays);
  }

  @override
  void goToProfitabillityPage() {
    navigateTo.navigate(pageRoute: PageRoutes.profitability);
  }

  @override
  void goToDepartmentsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.departments);
  }

  @override
  void goToSetGoalPage() {
    navigateTo.navigate(pageRoute: PageRoutes.setGoal);
  }

  @override
  void goToPaymentsTypePage() {
    navigateTo.navigate(pageRoute: PageRoutes.paymentsType);
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
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
      return;
    }

    try {
      isLoading = true;
      mainError = null;

      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = StatisticsHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: lastGetStatisticsParams,
        selectedDate: homePresenter.selectedDate,
        periodType: PeriodType.monthly,
      );

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
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
