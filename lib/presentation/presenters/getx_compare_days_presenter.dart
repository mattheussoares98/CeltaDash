import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCompareDaysPresenter extends GetxController
    with ErrorHandling, SaleStatisticsManager, UIErrorManager, LoadingManager
    implements CompareDaysPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxCompareDaysPresenter({
    required this.loadSaleStatistics,
  });

  @override
  Future<void> getSales({
    required DateTime? firstDay,
    required DateTime? secondDay,
    required HomePresenter homePresenter,
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (firstDay != null && firstDay == secondDay) {
        throw DomainError.sameDays;
      } else if (forceRefresh != true &&
          firstDay == _selectedFirstDay &&
          secondDay == _selectedSecondDay) {
        return;
      }

      _selectedFirstDay = firstDay;
      _selectedSecondDay = secondDay;
      List<SaleStatisticViewModel> firstDayMovements = [];
      List<SaleStatisticViewModel> secondDayMovements = [];

      if (firstDay != null) {
        final saleStatistics = await loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: firstDay,
            // groupByYear: true,
            // groupByMonth: true,
            // groupByDay: true,
            groupByHour: true,
            enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
            endDate: DateTime(
              firstDay.year,
              firstDay.month,
              firstDay.day,
            ),
          ),
        );

        firstDayMovements = saleStatistics
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
            .toList();
      }

      if (secondDay != null) {
        final saleStatistics = await loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: secondDay,
            // groupByYear: true,
            // groupByMonth: true,
            // groupByDay: true,
            groupByHour: true,
            enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
            endDate: DateTime(
              secondDay.year,
              secondDay.month,
              secondDay.day,
            ),
          ),
        );

        secondDayMovements = saleStatistics
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
            .toList();
      }

      saleStatistics = firstDayMovements + secondDayMovements;
    } catch (e) {
      mainError = getUIError(e);
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
}
