import 'package:get/get.dart';

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
      await loadSaleMovements.get(
        startDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        ),
        endDate: DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
        ).subtract(Duration(days: 1)),
        groupByProduct: true,
        groupByEnterprise: true,
        groupByDay: true,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
