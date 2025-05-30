import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSellerPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        SaleMovementManager,
        LastDateLoadedDataManager
    implements OperatorsProductivityPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxSellerPresenter({required this.loadSaleMovements});

  @override
  Future<void> getSales(homePresenter, {bool? forceRefresh}) async {
    isLoading = true;
    mainError = null;

    try {
      if (forceRefresh != true &&
          lastDateLoadedData?.year == homePresenter.selectedDate.year) {
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
        groupByHour: true,
        groupBySeller: true,
        groupByEnterprise: true,
      );

      saleMovements = remoteSales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      lastDateLoaded = homePresenter.selectedDate;
      homePresenter.updateScreen();
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
