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
      if (forceRefresh != true &&
          _lastDateLoadedData?.year == homePresenter.selectedDate.year &&
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

      final oldSales = [...?saleMovements];
      final newSales = <SaleMovementViewModel>[];

      for (var enterprise
          in homePresenter.enterprises ?? <EnterpriseViewModel>[]) {
        final remoteSales = await loadSaleMovements.get(
          enterpriseIds: [enterprise.id!.toInt()],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByDay: true,
          groupByMonth: true,
          groupByProductDepartment: true,
          groupByProductSection: true,
        );

        newSales.addAll(
          remoteSales.map((e) => SaleMovementModel.fromEntity(e).toViewModel()),
        );
        oldSales.removeWhere(
          (element) => element.EnterpriseId == enterprise.id,
        );
        saleMovements = [...oldSales, ...newSales];
      }

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
