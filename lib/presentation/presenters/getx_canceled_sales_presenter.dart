import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCanceledSalesPresenter extends GetxController
    with
        UIErrorManager,
        LoadingManager,
        EcSaleMovementManager,
        PeriodTypeManager,
        LastGetSaleMovementParamsManager
    implements CanceledSalesPresenter {
  final LoadSaleMovements loadSaleMovements;
  final NavigateTo navigateTo;

  GetxCanceledSalesPresenter({
    required this.loadSaleMovements,
    required this.navigateTo,
  });

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
      return;
    }

    isLoading = true;
    mainError = null;
    try {
      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = SearchHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: selectedPeriod == PeriodType.daily
            ? lastGetDailyParams
            : lastGetMonthlyParams,
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriod,
      );

      bool changedEnterprise = SearchHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriod,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastDailyParams: lastGetDailyParams,
        lastMonthlyParams: lastGetMonthlyParams,
      );

      if (!canSearchAgain && !changedEnterprise) {
        return;
      }

      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        selectedPeriod == PeriodType.daily ? homePresenter.selectedDate.day : 1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        0,
      );

      final params = GetSaleMovementParams(
        enterpriseIds: homePresenter.selectedEnterprise?.id == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: startDate,
        endDate: selectedPeriod == PeriodType.daily ? startDate : endDate,
        onlyCancelled: true,
      );
      final response = await loadSaleMovements.get(params);
      lastParams = params;

      final newSales = (response as List)
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
      if (selectedPeriod == PeriodType.daily) {
        lastGetDailyParams = params;
        dailySales = newSales;
      } else {
        lastGetMonthlyParams = params;
        monthlySales = newSales;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _selectedSale = Rx<SaleMovementViewModel?>(null);
  @override
  Stream<SaleMovementViewModel?> get selectedSaleStream =>
      _selectedSale.stream;
  set selectedSale(SaleMovementViewModel? value) {
    _selectedSale.value = null;
    _selectedSale.value = value;
  }

  @override
  void updateSelectedSaleMovement(SaleMovementViewModel sale) {
    selectedSale = sale;

    navigateTo.navigate(pageRoute: PageRoutes.canceledSaleDetails);
  }

  @override
  Future<void> getSelectedSaleDetails() async {
    isLoading = true;
    mainError = null;
    try {
      if (_selectedSale.value == null) {
        throw DomainError.unexpected;
      }
      final sale = SaleMovementModel.fromViewModel(_selectedSale.value!);
      final date = DateTime(
        sale.dateHourOfBilling!.year,
        sale.dateHourOfBilling!.month,
        sale.dateHourOfBilling!.day,
      );

      final loadedSale = await loadSaleMovements.get(
        GetSaleMovementParams(
          onlyCancelled: true,
          documentNumbers: [sale.documentNumber!],
          enterpriseIds: [sale.enterpriseId!],
          startDate: date,
          endDate: date,
          mountCustomer: true,
          mountFiscalNoteType: true,
          mountPaymentFinalizations: true,
          mountProducts: true,
          mountSeller: true,
        ),
      );

      if (loadedSale.isNotEmpty) {
        selectedSale =
            SaleMovementModel.fromEntity(loadedSale[0]).toViewModel();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
