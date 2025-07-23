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
  Future<bool> getSales(/* TODO add topCount param */) async {
    isLoading = true;
    mainError = null;
    try {
      if (startDate == null || endDate == null) {
        throw DomainError.selectPeriod;
      }

      final selectedParams = GetSaleStatisticsParams(
        startDate: startDate!,
        endDate: endDate!,
        enterpriseIds: _enterprisesIds,
        groupByYear: _periodGroupingTypes == PeriodGroupingType.year,
        groupByMonth: _periodGroupingTypes == PeriodGroupingType.month,
        groupByDay: _periodGroupingTypes == PeriodGroupingType.day,
        groupByHour: _periodGroupingTypes == PeriodGroupingType.hour,
        groupByProduct:
            _categoryGroupingTypes.contains(CategoryGroupingType.product),
        groupByEnterprise:
            _categoryGroupingTypes.contains(CategoryGroupingType.enterprise),
        groupByProductDepartment: _categoryGroupingTypes
            .contains(CategoryGroupingType.productDepartment),
        groupByProductSection: _categoryGroupingTypes
            .contains(CategoryGroupingType.productSection),
        groupByPaymentFinalization: _categoryGroupingTypes
            .contains(CategoryGroupingType.paymentFinalization),
        groupByPaymentModality: _categoryGroupingTypes
            .contains(CategoryGroupingType.paymentModality),
        groupByCashierOperator: _categoryGroupingTypes
            .contains(CategoryGroupingType.cashierOperator),
        groupBySeller:
            _categoryGroupingTypes.contains(CategoryGroupingType.seller),
        // topCount: ,
      );
      final sales = await loadSaleStatistics.get(selectedParams);

      saleStatistics = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      _lastGetStatisticsParams.value = selectedParams;
      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.personalized,
        periodType: PeriodType.personalized,
      );
      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
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
    const enterprise = CategoryGroupingType.enterprise;
    const paymentFinalization = CategoryGroupingType.paymentFinalization;
    const paymentModality = CategoryGroupingType.paymentModality;
    const productDepartment = CategoryGroupingType.productDepartment;
    const productSection = CategoryGroupingType.productSection;

    switch (type) {
      case enterprise:
        if (_categoryGroupingTypes.contains(type)) {
          _categoryGroupingTypes.remove(type);
        } else {
          _categoryGroupingTypes.add(type);
        }

        break;

      case productDepartment || productSection:
        if (_categoryGroupingTypes.contains(type)) {
          _categoryGroupingTypes.remove(type);
        } else {
          _categoryGroupingTypes.add(type);
        }
        _categoryGroupingTypes.removeWhere((e) =>
            e != enterprise && e != productDepartment && e != productSection);
        break;

      case paymentFinalization || paymentModality:
        if (_categoryGroupingTypes.contains(type)) {
          _categoryGroupingTypes.remove(type);
        } else {
          _categoryGroupingTypes.add(type);
        }
        _categoryGroupingTypes.removeWhere((e) =>
            e != enterprise &&
            e != paymentFinalization &&
            e != paymentModality);
        break;
      default:
        if (_categoryGroupingTypes.contains(type)) {
          _categoryGroupingTypes.remove(type);
        } else {
          _categoryGroupingTypes.add(type);
        }
        _categoryGroupingTypes.removeWhere((e) => e != enterprise && e != type);
    }
  }

  @override
  void changePeriodGroupingType(PeriodGroupingType type) {
    if (_periodGroupingTypes == type) {
      _periodGroupingTypes = null;
    } else {
      _periodGroupingTypes = type;
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

  final List<CategoryGroupingType> _categoryGroupingTypes = [];
  @override
  List<CategoryGroupingType> get categoryGroupingTypes =>
      _categoryGroupingTypes;

  PeriodGroupingType? _periodGroupingTypes;
  @override
  PeriodGroupingType? get periodGroupingType => _periodGroupingTypes;

  final _lastGetStatisticsParams = Rx<GetSaleStatisticsParams?>(null);
  @override
  GetSaleStatisticsParams? get lastGetStatisticsParams =>
      _lastGetStatisticsParams.value;
}
