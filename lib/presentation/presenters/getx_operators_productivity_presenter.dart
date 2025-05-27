import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxOperatorsProductivityPresenter extends GetxController
    with LoadingManager, UIErrorManager, SaleMovementManager
    implements OperatorsProductivityPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxOperatorsProductivityPresenter({required this.loadSaleMovements});

  @override
  Future<void> getSales(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;

    try {
      if (_lastDateLoadedData?.year == homePresenter.selectedDate.year) {
        return;
      }
      final remoteSales = await loadSaleMovements.get(
        // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year, 1, 1),
        endDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
          1,
        ).subtract(
          Duration(days: 1),
        ),
        groupByMonth: true,
        groupByDay: true,
        groupByHour: true,
        groupByCashierOperator: true,
        groupByEnterprise: true,
      );

      saleMovements = remoteSales
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
  DateTime? get lastDateLoadedData => _lastDateLoadedData; //TODO create manager
}
