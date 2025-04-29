import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPaymentTypePresenter extends GetxController
    with SaleMovementManager, UIErrorManager, LoadingManager
    implements PaymentTypePresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxPaymentTypePresenter({
    required this.loadSaleMovements,
  });

  @override
  Future<void> getSales(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;
    try {
      final result = await loadSaleMovements.get(
          startDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month + 1,
            1,
          ).subtract(Duration(days: 1)),
          groupByEnterprise: true,
          groupByDay: true,
          groupByMonth: true,
          groupByPaymentModality: true,
          enterpriseIds: homePresenter.selectedEnterprise?.id == null
              ? []
              : [homePresenter.selectedEnterprise!.id!.toInt()]);

      saleMovements = result
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
