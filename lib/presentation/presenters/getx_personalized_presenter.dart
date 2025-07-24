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
      if (_currentSelectedParams.value?.startDate == null ||
          _currentSelectedParams.value?.endDate == null) {
        throw DomainError.selectPeriod;
      }

      final sales = await loadSaleStatistics.get(_currentSelectedParams.value!);

      saleStatistics = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      _lastGetStatisticsParams.value = _currentSelectedParams.value;
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
    _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
          startDate: startDate,
          endDate: endDate,
        ) ??
        GetSaleStatisticsParams(
          startDate: startDate,
          endDate: endDate,
        );
  }

  @override
  void changeEnterpriseIds(int enterpriseId) {
    if (_currentSelectedParams.value == null) return;

    final oldEnterprises = _currentSelectedParams.value?.enterpriseIds ?? [];
    if (oldEnterprises.any((e) => e == enterpriseId) == true) {
      oldEnterprises.remove(enterpriseId);
    } else {
      oldEnterprises.add(enterpriseId);
    }

    _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
      enterpriseIds: oldEnterprises,
    );
  }

  bool _isSelected({
    required CategoryGroupingType type,
    required CategoryGroupingType groupingValidating,
    required bool selected,
    CategoryGroupingType? doesntAffectCurrentValue,
  }) {
    // If the clicked button corresponds to the property being validated, toggle its value.
    if (type == groupingValidating) {
      return !selected;
    }

    // The 'enterprise' grouping acts like a checkbox, independent of others.
    // We check if the property being updated is 'enterprise' OR if 'enterprise' was the one clicked.
    final bool isEnterpriseInvolved =
        groupingValidating == CategoryGroupingType.enterprise ||
            type == CategoryGroupingType.enterprise;

    // Preserve the current state if enterprise is involved or if it's a paired exclusion.
    if (isEnterpriseInvolved || type == doesntAffectCurrentValue) {
      return selected;
    }

    // For any other case, deselect the property (radio-button-like behavior).
    return false;
  }

  @override
  void changeCategoryGroupingType(CategoryGroupingType type) {
    if (_currentSelectedParams.value == null) return;

    final oldParams = _currentSelectedParams.value;

    _currentSelectedParams.value = oldParams?.copyWith(
      groupByEnterprise: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.enterprise,
        selected: oldParams.groupByEnterprise == true,
      ),
      groupByProduct: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.product,
        selected: oldParams.groupByProduct == true,
      ),
      groupByCashierOperator: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.cashierOperator,
        selected: oldParams.groupByCashierOperator == true,
      ),
      groupBySeller: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.seller,
        selected: oldParams.groupBySeller == true,
      ),
      groupByPaymentFinalization: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.paymentFinalization,
        selected: oldParams.groupByPaymentFinalization == true,
        doesntAffectCurrentValue: CategoryGroupingType.paymentModality,
      ),
      groupByPaymentModality: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.paymentModality,
        selected: oldParams.groupByPaymentModality == true,
        doesntAffectCurrentValue: CategoryGroupingType.paymentFinalization,
      ),
      groupByProductDepartment: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.productDepartment,
        selected: oldParams.groupByProductSection == true,
        doesntAffectCurrentValue: CategoryGroupingType.productSection,
      ),
      groupByProductSection: _isSelected(
        type: type,
        groupingValidating: CategoryGroupingType.productSection,
        selected: oldParams.groupByProductSection == true,
        doesntAffectCurrentValue: CategoryGroupingType.productDepartment,
      ),
    );
  }

  @override
  void changePeriodGroupingType(PeriodGroupingType type) {
    if (_currentSelectedParams.value == null) return;

    final groupByYear = _currentSelectedParams.value?.groupByYear == true;
    final groupByMonth = _currentSelectedParams.value?.groupByMonth == true;
    final groupByDay = _currentSelectedParams.value?.groupByDay == true;
    final groupByHour = _currentSelectedParams.value?.groupByHour == true;

    _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
      groupByYear: type == PeriodGroupingType.year && groupByYear == false,
      groupByMonth: type == PeriodGroupingType.month && groupByMonth == false,
      groupByDay: type == PeriodGroupingType.day && groupByDay == false,
      groupByHour: type == PeriodGroupingType.hour && groupByHour == false,
    );
  }

  @override
  void selectAllEnterprises() {
    if (_currentSelectedParams.value == null) {
      return;
    }

    _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
      enterpriseIds:
          homePresenter.enterprises?.map((e) => e.id!.toInt()).toList() ?? [],
    );
  }

  PeriodGroupingType? _periodGroupingTypes;
  @override
  PeriodGroupingType? get periodGroupingType => _periodGroupingTypes;

  final _lastGetStatisticsParams = Rx<GetSaleStatisticsParams?>(null);
  @override
  GetSaleStatisticsParams? get lastGetStatisticsParams =>
      _lastGetStatisticsParams.value;

  final _currentSelectedParams = Rx<GetSaleStatisticsParams?>(null);
  @override
  GetSaleStatisticsParams? get currentSelectedParams =>
      _currentSelectedParams.value;
}
