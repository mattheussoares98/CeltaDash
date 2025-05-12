import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager, SaleMovementManager
    implements ProductsPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxProductsPresenter({required this.loadSaleMovements});

  @override
  Future<void> loadProducts(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;
    try {
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
        enterpriseIds: homePresenter.selectedEnterprise == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
      );

      saleMovements = (response as List)
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
