import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
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
  final FirebaseManager firebaseManager;

  GetxResumePresenter({
    required this.navigateTo,
    required this.loadSaleStatistics,
    required this.firebaseManager,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();
  final homePresenter = Get.find<HomePresenter>();

  @override
  void goToGoalHistoricPage() {
    navigateTo.navigate(pageRoute: PageRoutes.goalHistoric);
  }

  @override
  void goToGroupSummaryPage() {
    navigateTo.navigate(pageRoute: PageRoutes.groupSummary);
  }

  @override
  Future<void> getSales({
    required DateTime now,
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    try {
      if (isLoadingValue == true ||
          homePresenter.selectedEnterprise?.id == null) {
        isLoading = false;
        isLoading = true;
        return;
      }

      isLoading = true;
      mainError = null;

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
        lastGetStatisticsParams: lastGetDailyComparisonParams,
      );

      if (changedEnterprise ||
          canSearchAgain ||
          homePresenter.selectedDate.day !=
              lastGetDailyComparisonParams?.startDate.day) {
        await _getCompareDaysStatistics(now);
        await _getCompareCurrentMonthAndPreviousYearMonthStatistics(now);
      }
      if (!canSearchAgain) {
        return;
      }

      if (_goals.value.isEmpty) {
        await _getGoals();
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
      ).subtract(const Duration(days: 1));

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
        periodType: selectedPeriod,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> _getCompareDaysStatistics(DateTime now) async {
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

    lastGetDailyComparisonParams = todayParams;

    _compareDaysStatistics.value = [
      ...todaySaleStatistics
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
      ...lastMonthSaleStatistics
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
    ];
  }

  Future<void> _getCompareCurrentMonthAndPreviousYearMonthStatistics(
    DateTime now,
  ) async {
    final defaultParams = GetSaleStatisticsParams(
      startDate: DateTime(0),
      endDate: DateTime(0),
      groupByEnterprise: true,
      groupByYear: true,
      groupByMonth: true,
      enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
    );

    final selectedMonthParams = defaultParams.copyWith(
      startDate: DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        1,
      ),
      endDate: DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        0,
      ),
    );
    final selectedMonthSaleStatistics =
        await loadSaleStatistics.get(selectedMonthParams);

    var comparisonParams = defaultParams.copyWith(
      startDate: DateTime(
        homePresenter.selectedDate.year - 1,
        homePresenter.selectedDate.month,
        1,
      ),
      endDate: DateTime(
        homePresenter.selectedDate.year - 1,
        homePresenter.selectedDate.month + 1,
        0,
      ),
    );
    var baseComparison = await loadSaleStatistics.get(comparisonParams);

    if (baseComparison.isEmpty) {
      //if doesnt exists sales from the previous year, load the previous month
      comparisonParams = defaultParams.copyWith(
        startDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month - 1,
          1,
        ),
        endDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          0,
        ),
      );

      baseComparison = await loadSaleStatistics.get(comparisonParams);
    }

    lastGetMonthlyComparisonParams = comparisonParams;

    _monthlyComparison.value = [
      ...selectedMonthSaleStatistics
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
      ...baseComparison
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
    ];
  }

  @override
  Future<void> setGoal(double value) async {
    isLoading = true;
    mainError = null;
    try {
      //TODO create tests

      await firebaseManager.put(
        path: goalPath,
        data: {goalId: value},
      );

      final enterpriseId = homePresenter.selectedEnterprise?.id;
      final selectedDate = homePresenter.selectedDate;
      _goals.value.add(
        GoalViewModel(
          FirebaseGoalEntity(
            enterpriseId: enterpriseId!.toInt(),
            year: selectedDate.year,
            month: selectedDate.month,
            value: value,
            goalId: goalId,
          ),
        ),
      );

      for (var x = 0; x < _goals.value.length; x++) {
        final goal = _goals.value[x];

        if (goal.enterpriseId == enterpriseId &&
            goal.goalEntity?.goalId == goalId) {
          _goals.value[x] = GoalViewModel(
            _goals.value[x].goalEntity!.copyWith(value: value),
          );

          break;
        }
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> _getGoals() async {
    //TODO create tests
    final doc = await firebaseManager.get(path: goalPath);

    if (doc.data() == null || doc.data()!.isEmpty) {
      _goals.value = [];
      return;
    }

    final goalsMap = doc.data()! as Map<String, dynamic>;

    final remoteGoals = goalsMap.entries.map((entry) {
      return FirebaseGoalModel.fromMapEntry(entry).toViewModel();
    }).toList();

    _goals.value = remoteGoals;
  }

  @override
  GoalViewModel? get firebaseEnterpriseGoal {
    //TODO create tests
    final index =
        _goals.value.indexWhere((e) => e.goalEntity?.goalId == goalId);

    if (index == -1) {
      return null;
    } else {
      return _goals.value[index];
    }
  }

  String get goalId {
    return "${homePresenter.selectedEnterprise?.id}-${DateFormat('yyyy-MM').format(homePresenter.selectedDate)}";
  }

  String get goalPath {
    return "enterprises/${EnterpriseBuilder.entity!.firebaseId}/goals/all";
  }

  final _compareDaysStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get compareDaysStatistics =>
      _compareDaysStatistics.value;
  set compareDaysStatistics(List<SaleStatisticViewModel>? value) =>
      _compareDaysStatistics.value = value;

  final _monthlyComparison = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get monthlyComparison =>
      _monthlyComparison.value;
  set monthlyComparison(List<SaleStatisticViewModel>? value) =>
      _monthlyComparison.value = value;

  final _goals = Rx<List<GoalViewModel>>([]);
  @override
  List<GoalViewModel> get goals => _goals.value;
}
