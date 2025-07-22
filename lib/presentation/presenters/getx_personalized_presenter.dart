import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxPersonalizedPresenter extends GetxController
    with ErrorHandling, SaleStatisticsManager, UIErrorManager, LoadingManager
    implements PersonalizedPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxPersonalizedPresenter({
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();
  final homePresenter = Get.find<HomePresenter>();

  @override
  Future<void> getSales(/* TODO add topCount param */) async {
    isLoading = true;
    mainError = null;
    try {
      if (startDate == null || endDate == null) {
        throw DomainError.selectPeriod;
      }
      final sales = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: startDate!,
          endDate: endDate!,
          enterpriseIds: _enterprisesIds,
          groupByEnterprise: true, //TODO add new parameter
          groupByYear: _periodGroupingTypes.contains(PeriodGroupingType.year),
          groupByMonth: _periodGroupingTypes.contains(PeriodGroupingType.month),
          groupByDay: _periodGroupingTypes.contains(PeriodGroupingType.day),
          groupByHour: _periodGroupingTypes.contains(PeriodGroupingType.hour),
          groupByProduct: _categoryGroupingType == CategoryGroupingType.product,
          groupByProductDepartment:
              _categoryGroupingType == CategoryGroupingType.productDepartment,
          groupByProductSection:
              _categoryGroupingType == CategoryGroupingType.productSection,
          groupByPaymentFinalization:
              _categoryGroupingType == CategoryGroupingType.paymentFinalization,
          groupByPaymentModality:
              _categoryGroupingType == CategoryGroupingType.paymentModality,
          groupByCashierOperator:
              _categoryGroupingType == CategoryGroupingType.cashierOperator,
          groupBySeller: _categoryGroupingType == CategoryGroupingType.seller,
          // topCount: ,
        ),
      );

      saleStatistics = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.personalized,
        periodType: PeriodType.personalized,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void changeDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
  }

  @override
  void changeEnterpriseIds(int enterpriseId) {
    if (_enterprisesIds.contains(enterpriseId)) {
      _enterprisesIds.remove(enterpriseId);
    } else {
      _enterprisesIds.add(enterpriseId);
    }
  }

  @override
  void changeCategoryGroupingType(CategoryGroupingType type) {
    if (_categoryGroupingType == type) {
      _categoryGroupingType = null;
    } else {
      _categoryGroupingType = type;
    }
  }

  @override
  void changePeriodGroupingType(PeriodGroupingType type) {
    if (_periodGroupingTypes.contains(type)) {
      _periodGroupingTypes.remove(type);
    } else {
      _periodGroupingTypes.add(type);
    }
  }

  @override
  void selectAllEnterprises() {
    _enterprisesIds =
        homePresenter.enterprises?.map((e) => e.id!.toInt()).toList() ?? [];
  }

  DateTime? _endDate;
  @override
  DateTime? get endDate => _endDate;

  DateTime? _startDate;
  @override
  DateTime? get startDate => _startDate;

  List<int> _enterprisesIds = [];
  @override
  List<int> get enterprisesIds => _enterprisesIds;

  CategoryGroupingType? _categoryGroupingType;
  @override
  CategoryGroupingType? get categoryGroupingType => _categoryGroupingType;

  final List<PeriodGroupingType> _periodGroupingTypes = [];
  @override
  List<PeriodGroupingType> get periodGroupingTypes => _periodGroupingTypes;
}
