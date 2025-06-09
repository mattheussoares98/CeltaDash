import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCanceledSalesPresenter extends GetxController
    with UIErrorManager, LoadingManager
    implements CanceledSalesPresenter {
  final EcLoadSaleMovements ecLoadSaleMovements;

  GetxCanceledSalesPresenter({
    required this.ecLoadSaleMovements,
  });

  @override
  Future<void> getSales(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;

    try {
      final sales = await ecLoadSaleMovements.get(
        GetEcSaleMovementParams(
          EnterpriseIds: homePresenter.selectedEnterprise?.id == null
              ? []
              : [homePresenter.selectedEnterprise!.id!.toInt()],
          StartDate: homePresenter.selectedDate,
          EndDate: homePresenter.selectedDate,
          OnlyCancelled: true,
        ),
      );

      ecSaleMovements = sales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _ecSaleMovements = Rx<List<EcSaleMovementViewModel>?>(null);
  @override
  List<EcSaleMovementViewModel>? get ecSaleMovements => _ecSaleMovements.value;
  set ecSaleMovements(List<EcSaleMovementViewModel>? value) =>
      _ecSaleMovements.value = value;
}
