import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSalesPresenter extends GetxController
    with SaleMovementManager, LoadingManager, UIErrorManager
    implements SalesPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxSalesPresenter({required this.loadSaleMovements});

  @override
  Future<void> getSales({
    required HomePresenter homePresenter,
    required ResumePresenter resumePresenter,
    bool? searchByHour,
    bool? searchByDay,
    bool? searchByMonth,
    bool? searchByYear,
    bool? forceRefresh,
  }) async {
    mainError = null;
    isLoading = true;

    try {
      if (searchByHour != true &&
          searchByDay != true &&
          searchByMonth != true &&
          searchByYear != true &&
          forceRefresh != true) {
        throw DomainError.unexpected;
      } else if (searchByHour == true || searchByDay == true) {
        await resumePresenter.getSales(
          homePresenter,
          forceRefresh: forceRefresh,
        );
        return;
      }

      final remoteSales = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year),
        endDate: DateTime(homePresenter.selectedDate.year),
        groupByEnterprise: true,
        groupByMonth: true,
        groupByYear: true,
      );

      saleMovements = remoteSales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
