import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSalesPresenter extends GetxController
    with LoadingManager, UIErrorManager, LastDateLoadedDataManager
    implements SalesPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxSalesPresenter({required this.loadSaleMovements});

  @override
  Future<void> getSales({
    required HomePresenter homePresenter,
    required ResumePresenter resumePresenter,
    bool? forceRefresh,
  }) async {
    mainError = null;
    isLoading = true;

    try {
      if (homePresenter.selectedDate.year == lastDateLoadedData?.year &&
          homePresenter.selectedEnterprise == _lastEnterpriseLoadedData &&
          forceRefresh != true) {
        return;
      }

      final now = DateTime.now();
      final remoteSalesByMonth = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year, 1, 1),
        endDate: DateTime(now.year, now.month,
            now.day), //TODO fix this. When the user change the year, it should load the same year data
        groupByEnterprise: true,
        groupByDay: true,
      );
      salesByMonth = remoteSalesByMonth
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      final remoteSalesByYear = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year - 2),
        endDate: DateTime(now.year, now.month, now.day),
        groupByEnterprise: true,
        groupByYear: true,
      );

      salesByYear = remoteSalesByYear
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      lastDateLoaded = homePresenter.selectedDate;
      _lastEnterpriseLoadedData = homePresenter.selectedEnterprise;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedPeriod({
    bool? filterByHour,
    bool? filterByDay,
    bool? filterByMonth,
    bool? filterByYear,
  }) {
    _filterByHour = filterByHour ?? false;
    _filterByDay = filterByDay ?? false;
    _filterByMonth = filterByMonth ?? false;
    _filterByYear = filterByYear ?? false;
  }

  final _saleMovementsByYear = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByYear =>
      _saleMovementsByYear.value;
  set salesByYear(List<SaleMovementViewModel>? value) =>
      _saleMovementsByYear.value = value;

  final _saleMovementsByMonth = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByMonth =>
      _saleMovementsByMonth.value;
  set salesByMonth(List<SaleMovementViewModel>? value) =>
      _saleMovementsByMonth.value = value;

  bool _filterByHour = true;
  @override
  bool get filterByHour => _filterByHour;

  bool _filterByDay = false;
  @override
  bool get filterByDay => _filterByDay;

  bool _filterByMonth = false;
  @override
  bool get filterByMonth => _filterByMonth;

  bool _filterByYear = false;
  @override
  bool get filterByYear => _filterByYear;

  EnterpriseViewModel? _lastEnterpriseLoadedData;
  @override
  EnterpriseViewModel? get lastEnterpriseLoadedData =>
      _lastEnterpriseLoadedData;
}
