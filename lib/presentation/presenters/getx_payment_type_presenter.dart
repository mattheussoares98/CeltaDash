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
  Future<void> getSales(HomePresenter homePresenter,
      {bool? forceRefresh}) async {
    isLoading = true;
    mainError = null;
    try {
      if (forceRefresh == true) {
        //continue...
      } else if (_lastDateLoadedData?.year == homePresenter.selectedDate.year &&
          _lastDateLoadedData?.month == homePresenter.selectedDate.month) {
        return;
      }
      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        1,
      ).subtract(Duration(days: 1));

      final salesByModality = await loadSaleMovements.get(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByMonth: true,
        groupByPaymentModality: true,
      );

      saleMovements = salesByModality
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      final salesByFinalization = await loadSaleMovements.get(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByMonth: true,
        groupByPaymentFinalization: true,
      );

      salesByFinaliztions = salesByFinalization
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
  void emitLoadingAgain() {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
    }
  }

  final _saleMovementsFinalizations = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByFinalizations =>
      _saleMovementsFinalizations.value;
  set salesByFinaliztions(List<SaleMovementViewModel>? value) =>
      _saleMovementsFinalizations.value = value;

  DateTime? _lastDateLoadedData;
  @override
  DateTime? get lastDateLoadedData => _lastDateLoadedData;
}
