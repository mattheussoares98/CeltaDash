import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxBsSalesPresenter extends GetxController
    with
        ErrorHandling,
        UIErrorManager,
        LoadingManager,
        PeriodTypeManager,
        LastGetSaleMovementParamsManager
    implements BsSalesPresenter {
  final LoadSaleMovements loadSaleMovements;
  final NavigateTo navigateTo;

  GetxBsSalesPresenter({
    required this.loadSaleMovements,
    required this.navigateTo,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();
  final homePresenter = Get.find<HomePresenter>();

  @override
  Future<void> getCanceledSales(
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

      final newSales = SaleMovementModel.fromEntity(response).toViewModel();
      if (selectedPeriod == PeriodType.daily) {
        lastGetDailyParams = params;
        _dailyCanceledSales.value = newSales;
      } else {
        lastGetMonthlyParams = params;
        _monthlyCanceledSales.value = newSales;
      }

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.canceledSales,
        periodType: selectedPeriod,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedSaleMovement(SaleMovementCollectionItemViewModel sale) {
    selectedSale = sale;

    navigateTo.navigate(pageRoute: PageRoutes.bsSaleDetails);
  }

  @override
  Future<void> getSelectedSaleDetails() async {
    isLoading = true;
    mainError = null;
    try {
      if (_selectedSale.value == null) {
        throw DomainError.unexpected;
      }
      final sale =
          SaleMovementCollectionItemModel.fromViewModel(_selectedSale.value!);
      final date = DateTime(
        sale.dateHourOfBilling!.year,
        sale.dateHourOfBilling!.month,
        sale.dateHourOfBilling!.day,
      );

      final loadedSale = await loadSaleMovements.get(
        GetSaleMovementParams(
          documentNumbers: [sale.documentNumber!],
          enterpriseIds: [sale.enterpriseId!],
          startDate: date,
          endDate: date,
          mountCustomer: true,
          mountFiscalNoteType: true,
          mountProducts: true,
          mountSeller: true,
          mountPaymentFinalizations: true,
        ),
      );

      if (loadedSale.collection.isNotEmpty) {
        selectedSale =
            SaleMovementCollectionItemModel.fromEntity(loadedSale.collection[0])
                .toViewModel();
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> getNotCanceledSales([int? actualPage]) async {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
      return;
    }

    isLoading = true;
    mainError = null;
    try {
      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        homePresenter.selectedDate.day,
      );

      final params = GetSaleMovementParams(
        enterpriseIds: homePresenter.selectedEnterprise?.id == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: startDate,
        endDate: startDate,
        onlyNotCancelled: true,
        actualPage: actualPage ?? 1,
      );
      final response = await loadSaleMovements.get(params);
      lastParams = params;

      final newSales = SaleMovementModel.fromEntity(response).toViewModel();

      _notCanceledSales.value = newSales;

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.notCanceledSales,
        periodType: PeriodType.daily,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> changeSalesPage(bool isAdvancing) async {
    try {
      final oldIndex = _notCanceledSales.value?.actualPage ?? 1;
      int newIndex = isAdvancing ? oldIndex + 1 : oldIndex - 1;

      final maxIndex = _notCanceledSales.value?.totalPages ?? 1;

      if (newIndex < 1 || newIndex > maxIndex) return;

      await getNotCanceledSales(newIndex);
    } catch (e) {
      //the error is already treated in getNotCanceledSales
    }
  }

  final _selectedSale = Rx<SaleMovementCollectionItemViewModel?>(null);
  @override
  Stream<SaleMovementCollectionItemViewModel?> get selectedSaleStream =>
      _selectedSale.stream;
  set selectedSale(SaleMovementCollectionItemViewModel? value) {
    _selectedSale.value = null;
    _selectedSale.value = value;
  }

  final _dailyCanceledSales = Rx<SaleMovementViewModel?>(null);
  @override
  SaleMovementViewModel? get dailyCanceledSales => _dailyCanceledSales.value;

  final _monthlyCanceledSales = Rx<SaleMovementViewModel?>(null);
  @override
  SaleMovementViewModel? get monthlyCanceledSales =>
      _monthlyCanceledSales.value;

  final _notCanceledSales = Rx<SaleMovementViewModel?>(null);
  @override
  SaleMovementViewModel? get notCanceledSales => _notCanceledSales.value;
}
