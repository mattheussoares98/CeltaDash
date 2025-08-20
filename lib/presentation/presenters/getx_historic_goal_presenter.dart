import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxGoalHistoricPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements GoalHistoricPresenter {
  final FirebaseManager firebaseManager;
  final LoadSaleStatistics loadSaleStatistics;

  GetxGoalHistoricPresenter({
    required this.firebaseManager,
    required this.loadSaleStatistics,
  });

  @override
  Future<void> loadHistoricSales() async {
    isLoading = true;
    mainError = null;
    try {
      await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ),
      );
      // TODO: implement loadHistoricSales
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
