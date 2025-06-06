import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxDepartmentsPresenter extends GetxController
    with
        SaleMovementManager,
        UIErrorManager,
        LoadingManager,
        LastGetSalesParamsManager,
        PeriodTypeManager
    implements DepartmentsPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxDepartmentsPresenter({
    required this.loadSaleMovements,
  });

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      return;
    }
    try {
      isLoading = true;
      mainError = null;

      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = SalesHelper.canSearch(
        forceRefresh: forceRefresh,
        lastGetSalesParams: lastGetSalesParams,
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriodValue,
      );

      if (!canSearchAgain) {
        return;
      }

      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        selectedPeriodValue == PeriodType.daily
            ? homePresenter.selectedDate.day
            : 1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        1,
      ).subtract(Duration(days: 1));

      final getSalesParams = GetSalesParams(
        startDate: startDate,
        endDate: selectedPeriodValue == PeriodType.daily ? startDate : endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByProductDepartment: true,
        groupByProductSection: true,
      );
      final remoteSales = await loadSaleMovements.get(getSalesParams);
      lastParams = getSalesParams;

      saleMovements = remoteSales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void emitLoadingAgain() {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
    }
  }
}
