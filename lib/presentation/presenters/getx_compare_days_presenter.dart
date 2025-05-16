import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCompareDaysPresenter extends GetxController
    with SaleMovementManager, UIErrorManager, LoadingManager
    implements CompareDaysPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxCompareDaysPresenter({
    required this.loadSaleMovements,
  });

  @override
  Future<void> getSales({
    required DateTime? firstDay,
    required DateTime? secondDay,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (firstDay != null && firstDay == secondDay) {
        throw DomainError.sameDays;
      }

      _selectedFirstDay = firstDay;
      _selectedSecondDay = secondDay;
      List<SaleMovementViewModel> firstDayMovements = [];
      List<SaleMovementViewModel> secondDayMovements = [];

      if (firstDay != null) {
        final saleMovements = await loadSaleMovements.get(
          startDate: firstDay,
          groupByYear: true,
          groupByMonth: true,
          groupByDay: true,
          groupByHour: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          endDate: DateTime(
            firstDay.year,
            firstDay.month,
            firstDay.day,
            23,
            59,
            59,
          ),
        );

        firstDayMovements = saleMovements
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList();
      }

      if (secondDay != null) {
        final saleMovements = await loadSaleMovements.get(
          startDate: secondDay,
          groupByYear: true,
          groupByMonth: true,
          groupByDay: true,
          groupByHour: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          endDate: DateTime(
            secondDay.year,
            secondDay.month,
            secondDay.day,
            23,
            59,
            59,
          ),
        );

        secondDayMovements = saleMovements
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList();
      }

      saleMovements = firstDayMovements + secondDayMovements;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.sameDays:
          mainError = UIError.sameDays;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  DateTime? _selectedFirstDay;
  @override
  DateTime? get selectedFirstDay => _selectedFirstDay;

  DateTime? _selectedSecondDay;
  @override
  DateTime? get selectedSecondDay => _selectedSecondDay;

  @override
  void clear() {
    saleMovements = null;
  }
}
