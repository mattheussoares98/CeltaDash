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
  Future<void> getSales(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;
    try {
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

      final enterpriseIds = homePresenter.selectedEnterprise?.id == null
          ? <int>[]
          : [homePresenter.selectedEnterprise!.id!.toInt()];

      final salesByModality = await loadSaleMovements.get(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByMonth: true,
        enterpriseIds: enterpriseIds,
        groupByProductDepartment: true,
        groupByProductSection: true,
      );

      saleMovements = salesByModality
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      final salesByFinalization = await loadSaleMovements.get(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByMonth: true,
        groupByPaymentFinalization: true,
        enterpriseIds: enterpriseIds,
      );

      salesByFinaliztions = salesByFinalization
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _saleMovementsBySection = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsBySection =>
      _saleMovementsBySection.value;
  set salesByFinaliztions(List<SaleMovementViewModel>? value) =>
      _saleMovementsBySection.value = value;
}
