import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxHistoricGoalPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager, SaleStatisticsManager
    implements HistoricGoalPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxHistoricGoalPresenter({
    required this.loadSaleStatistics,
  });

  final homePresenter = Get.find<HomePresenter>();

  @override
  Future<void> loadHistoricSales(int year) async {
    isLoading = true;
    mainError = null;
    try {
      if (year < 2025) {
        mainError =
            UIError.custom("${R.string.msgHistoricGoalAvailableSince} 2025");
        return;
      }

      final remoteSales = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.year == 2025 ? 8 : 1,
            1,
          ),
          endDate: DateTime(homePresenter.selectedDate.year, 12, 31),
          groupByMonth: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        ),
      );

      saleStatistics = remoteSales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

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
}
