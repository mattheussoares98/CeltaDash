import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxCompareMonthsPresenter extends GetxController
    with ErrorHandling, UIErrorManager, LoadingManager
    implements CompareMonthsPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxCompareMonthsPresenter({
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();

  @override
  Future<void> getSales({
    required DateTime now,
    DateTime? selectedDate,
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (_previousMonth.value != null &&
          _previousYear.value != null &&
          _selectedMonth.value != null &&
          forceRefresh != true) {
        return;
      }

      final selectedDateIsToday = selectedDate == null ||
          selectedDate.year == now.year &&
              selectedDate.month == now.month &&
              selectedDate.day == now.day;
      final dateToUse = selectedDate ?? now;

      final selectedMonthRemote = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime(
            dateToUse.year,
            dateToUse.month,
            1,
            selectedDateIsToday ? now.hour : 0,
          ),
          endDate: DateTime(
            dateToUse.year,
            dateToUse.month + 1,
            0,
            selectedDateIsToday ? now.hour : 0,
          ),
        ),
      );
      _selectedMonth.value = selectedMonthRemote
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      final previousMonthRemote = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime(
            dateToUse.year,
            dateToUse.month - 1,
            1,
            selectedDateIsToday ? now.hour : 0,
          ),
          endDate: DateTime(
            dateToUse.year,
            dateToUse.month - 1,
            0,
            selectedDateIsToday ? now.hour : 0,
          ),
        ),
      );

      _previousMonth.value = previousMonthRemote
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      final previousYearRemote = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: DateTime(
            dateToUse.year - 1,
            dateToUse.month,
            1,
            selectedDateIsToday ? now.hour : 0,
          ),
          endDate: DateTime(
            dateToUse.year - 1,
            dateToUse.month - 1,
            0,
            selectedDateIsToday ? now.hour : 0,
          ),
        ),
      );

      _previousYear.value = previousYearRemote
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.compareMonths,
        periodType: PeriodType.monthly,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  final _previousYear = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get previousYear => _previousYear.value;

  final _selectedMonth = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get selectedMonth => _selectedMonth.value;

  final _previousMonth = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get previousMonth => _previousMonth.value;
}
