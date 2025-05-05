import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxResumePresenter extends GetxController
    with SaleMovementManager, UIErrorManager, LoadingManager
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
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (_lastDateLoadedData?.year == homePresenter.selectedDate.year &&
          forceRefresh != true) {
        return;
      }
      final result = await loadSaleMovements.get(
        startDate: DateTime(
          homePresenter.selectedDate.year,
          1,
          1,
        ),
        endDate: DateTime(
          homePresenter.selectedDate.year,
          DateTime.now().month + 1,
          1,
        ).subtract(Duration(days: 1)),
        groupByEnterprise: true,
        groupByDay: true,
        groupByMonth: true,
        groupByHour: true,
      );

      saleMovements = result
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      _lastDateLoadedData = homePresenter.selectedDate;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  DateTime? _lastDateLoadedData;
  @override
  DateTime? get lastDateLoadedData => _lastDateLoadedData;
}
