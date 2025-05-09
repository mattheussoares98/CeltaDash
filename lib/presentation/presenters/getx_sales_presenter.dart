import 'package:flutter/foundation.dart';
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
    bool? searchByHour,
    bool? searchByDay,
    bool? searchByMonth,
    bool? searchByYear,
    bool? forceRefresh,
  }) async {
    mainError = null;
    isLoading = true;

    try {
      late DateTime startDate;
      late DateTime endDate;

      if (searchByHour == true || searchByDay == true) {
        if (forceRefresh != true &&
            homePresenter.selectedDate.month == _lastLoadedDate?.month &&
            homePresenter.selectedDate.year == _lastLoadedDate?.year) {
          return;
        }

        startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        );
        endDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
        ).subtract(Duration(days: 1));
      } else if (searchByMonth == true || searchByYear == true) {
        startDate = DateTime(homePresenter.selectedDate.year);
        endDate = DateTime(homePresenter.selectedDate.year);
      } else {
        throw DomainError.unexpected;
      }

      final remoteSales = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByHour: searchByHour == true || searchByDay == true,
        groupByDay: searchByHour == true || searchByDay == true,
        groupByMonth: (searchByMonth == true || searchByYear == true) &&
            (searchByHour != true && searchByDay != true),
        groupByYear: (searchByMonth == true || searchByYear == true) &&
            (searchByHour != true && searchByDay != true),
      );

      debugPrint("stop");

      saleMovements = remoteSales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      _lastLoadedDate = homePresenter.selectedDate;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  DateTime? _lastLoadedDate;
  @override
  DateTime? get lastLoadedDate => _lastLoadedDate;
}
