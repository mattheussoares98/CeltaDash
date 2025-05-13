import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSalesPresenter extends GetxController
    with LoadingManager, UIErrorManager
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
      //TODO create a getter to verify if was changed the enterprise
      if (homePresenter.selectedDate.year == _lastDateLoadedData?.year &&
          forceRefresh != true) {
        return;
      }

      final remoteSalesByMonth = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year, 1, 1),
        // endDate: DateTime(homePresenter.selectedDate.year, 12, 31),
        endDate: DateTime
            .now(), //TODO Cardoso needs to fix the problem when filter a entire year to remove this DateTime.now
        groupByEnterprise: true,
        groupByMonth: true,
        groupByYear: true,
      );
      salesByMonth = remoteSalesByMonth
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      final remoteSalesByYear = await loadSaleMovements.get(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: DateTime(homePresenter.selectedDate.year - 2),
        endDate: DateTime(homePresenter.selectedDate.year, 12, 31),
        groupByEnterprise: true,
        groupByYear: true,
      );

      salesByYear = remoteSalesByYear
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      _lastDateLoadedData = homePresenter.selectedDate;
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

  DateTime? _lastDateLoadedData;
  @override
  DateTime? get lastDateLoadedData => _lastDateLoadedData;
}
