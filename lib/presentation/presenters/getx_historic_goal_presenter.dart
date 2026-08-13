import 'package:celta_dash/utils/utils.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxHistoricGoalPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements HistoricGoalPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxHistoricGoalPresenter({required this.loadSaleStatistics});

  final homePresenter = Get.find<HomePresenter>();
  final resumePresenter = Get.find<ResumePresenter>();

  @override
  Future<void> loadHistoricSales(int year) async {
    isLoading = true;
    mainError = null;
    try {
      if (year < 2025) {
        mainError = UIError.custom(
          "${R.string.msgHistoricGoalAvailableSince} 2025",
        );
        return;
      }

      final selectedYearRemoteSales = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime(year, year == 2025 ? 7 : 1),
          endDate: DateTime(year, 12, 31),
          groupByMonth: true,
          groupByYear: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()!],
        ),
      );

      final previousYearRemoteSales = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime(year - 1, year == 2025 ? 8 : 1),
          endDate: DateTime(year - 1, 12, 31),
          groupByMonth: true,
          groupByYear: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()!],
        ),
      );

      selectedYearSalesStatistics = [
        ...selectedYearRemoteSales.map(
          (e) => SaleStatisticsModel.fromEntity(e).toViewModel(),
        ),
        ...previousYearRemoteSales.map(
          (e) => SaleStatisticsModel.fromEntity(e).toViewModel(),
        ),
      ];

      //! already has the goals in resume presenter because load there
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  String get goalPath {
    return "enterprises/${EnterpriseBuilder.entity!.firebaseId}/goals/all";
  }

  @override
  double getGoalValue(int year, int month) {
    //TODO use this function in monthlyComparison

    final manualGoal = resumePresenter.goals
        .where(
          (e) =>
              e.goalEntity?.year == year &&
              e.goalEntity?.month == month &&
              e.goalEntity?.enterpriseId ==
                  homePresenter.selectedEnterprise!.id!.toInt()!,
        )
        .toList();

    if (manualGoal.isNotEmpty) {
      return manualGoal.first.goalEntity!.value;
    } else {
      final previousYearSameMonthSales = _selectedYearSalesStatistics.value
          ?.filteredSales(filterYear: year - 1, filterMonth: month)
          .map((e) => e.toViewModel())
          .toList();

      if (previousYearSameMonthSales != null &&
          previousYearSameMonthSales.isNotEmpty) {
        return (previousYearSameMonthSales.sumLiquidValue() * 1.05)
            .toStringAsFixed(2)
            .toDouble()!;
      } else {
        return ((_selectedYearSalesStatistics.value
                        ?.filteredSales(
                          filterYear: year,
                          filterMonth: month - 1,
                        )
                        .map((e) => e.toViewModel())
                        .toList()
                        .sumLiquidValue() ??
                    1) *
                1.05)
            .toStringAsFixed(2)
            .toDouble()!;
      }
    }
  }

  final _selectedYearSalesStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get selectedYearSalesStatistics =>
      _selectedYearSalesStatistics.value;
  set selectedYearSalesStatistics(List<SaleStatisticViewModel>? value) =>
      _selectedYearSalesStatistics.value = value;
}
