import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxDepartmentsPresenter extends GetxController
    with SaleMovementManager, UIErrorManager, LoadingManager
    implements DepartmentsPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxDepartmentsPresenter({
    required this.loadSaleMovements,
  });

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (forceRefresh == true) {
        //continue...
      } else if (_lastDateLoadedData?.year == homePresenter.selectedDate.year &&
          _lastDateLoadedData?.month == homePresenter.selectedDate.month) {
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

      final salesByModality = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByMonth: true,
        groupByProductDepartment: true,
        groupByProductSection: true,
      );

      saleMovements = salesByModality
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

  @override
  void emitLoadingAgain() {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
    }
  }
}
