import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
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
  final homePresenter = Get.find<HomePresenter>();

  @override
  Future<void> getSales() async {
    mainError = null;
    isLoading = true;

    try {
      if (_firstSelectedMonth == _secondSelectedMonth &&
          _firstSelectedYear == _secondSelectedYear) {
        mainError = UIError.custom(R.string.msgSamePeriod);
        return;
      }
      final firstMonthSalesRemote = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          groupByDay: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(
            firstSelectedYear,
            firstSelectedMonth,
            1,
          ),
          endDate: DateTime(
            firstSelectedYear,
            firstSelectedMonth + 1,
            0,
          ),
        ),
      );

      final secondMonthSalesRemote = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          groupByDay: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(
            secondSelectedYear,
            secondSelectedMonth,
            1,
          ),
          endDate: DateTime(
            secondSelectedYear,
            secondSelectedMonth + 1,
            0,
          ),
        ),
      );

      _firstMonthSales.assignAll(firstMonthSalesRemote.map(
        (e) => SaleStatisticsModel.fromEntity(e).toViewModel(),
      ));
      _secondMonthSales.assignAll(secondMonthSalesRemote.map(
        (e) => SaleStatisticsModel.fromEntity(e).toViewModel(),
      ));
    } catch (error) {
      mainError = getUIError(error);
    } finally {
      isLoading = false;
    }
  }

  final _firstMonthSales = <SaleStatisticViewModel>[].obs;
  @override
  List<SaleStatisticViewModel> get firstMonthSales => _firstMonthSales;

  final _secondMonthSales = <SaleStatisticViewModel>[].obs;
  @override
  List<SaleStatisticViewModel> get secondMonthSales => _secondMonthSales;

  static final _now = DateTime.now();

  @override
  void changeFirstSelectedMonth(int month) {
    _firstSelectedMonth = month;
  }

  @override
  void changeFirstSelectedYear(int year) {
    _firstSelectedYear = year;
  }

  @override
  void changeSecondSelectedMonth(int month) {
    _secondSelectedMonth = month;
  }

  @override
  void changeSecondSelectedYear(int year) {
    _secondSelectedYear = year;
  }

  int _firstSelectedMonth = _now.month - 1;
  @override
  int get firstSelectedMonth => _firstSelectedMonth;

  int _firstSelectedYear = _now.year;
  @override
  int get firstSelectedYear => _firstSelectedYear;

  int _secondSelectedMonth = _now.month;
  @override
  int get secondSelectedMonth => _secondSelectedMonth;

  int _secondSelectedYear = _now.year;
  @override
  int get secondSelectedYear => _secondSelectedYear;
}
