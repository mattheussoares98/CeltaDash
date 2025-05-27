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
      final remoteSales = await loadSaleMovements.get(
        // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year, 1, 1),
        endDate: DateTime(homePresenter.selectedDate.year,
                homePresenter.selectedDate.month + 1, 1)
            .subtract(
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
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  bool _selectedMonth = false;
  @override
  bool get selectedMonth => _selectedMonth;

  @override
  void updateSelectedMonth(bool value) {
    _selectedMonth = value;
  }
}
