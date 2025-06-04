import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxResumePresenter extends GetxController
    with
        SaleMovementManager,
        UIErrorManager,
        LoadingManager,
        LastGetSalesParamsManager
    implements ResumePresenter {
  final NavigateTo navigateTo;
  final LoadSaleMovements loadSaleMovements;

  GetxResumePresenter({
    required this.navigateTo,
    required this.loadSaleMovements,
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
      return;
    }
    try {
      isLoading = true;
      mainError = null;

      if (periodType != null) {
        _selectedPeriodType = periodType;
      }

      final canSearchAgain = SalesHelper.canSearch(
        forceRefresh: forceRefresh,
        lastGetSalesParams: lastGetSalesParams,
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
      //TODO create function in helper to get start and end dates
      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        1,
      ).subtract(Duration(days: 1));

      final salesParams = GetSalesParams(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByHour: true,
      );
      final result = await loadSaleMovements.get(salesParams);

      saleMovements = result
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      lastParams = salesParams;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  PeriodType _selectedPeriodType = PeriodType.daily;
  @override
  PeriodType? get selectedPeriodType => _selectedPeriodType;
}
