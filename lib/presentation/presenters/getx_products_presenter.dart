import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxProductsPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        SaleMovementManager,
        LastDateLoadedDataManager
    implements ProductsPresenter {
  final LoadSaleMovements loadSaleMovements;
  final LocalStorage localStorage;

  GetxProductsPresenter({
    required this.loadSaleMovements,
    required this.localStorage,
  });

  @override
  Future<void> loadProducts(
    HomePresenter homePresenter, {
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (forceRefresh != true &&
          (homePresenter.selectedEnterprise == _lastEnterpriseLoadedData) &&
          (lastDateLoadedData?.year == homePresenter.selectedDate.year &&
              lastDateLoadedData?.month == homePresenter.selectedDate.month &&
              lastDateLoadedData?.day == homePresenter.selectedDate.day)) {
        return;
      }
      final response = await loadSaleMovements.get(
        startDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        ),
        endDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
        ).subtract(Duration(days: 1)),
        groupByDay: true,
        groupByProduct: true,
        groupByEnterprise: true,
        topCount: 200,
        enterpriseIds: homePresenter.selectedEnterprise == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
      );

      saleMovements = (response as List)
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      _lastEnterpriseLoadedData = homePresenter.selectedEnterprise;
      lastDateLoaded = homePresenter.selectedDate;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  EnterpriseViewModel? _lastEnterpriseLoadedData;
  @override
  EnterpriseViewModel? get lastEnterpriseLoadedData =>
      _lastEnterpriseLoadedData;
}
