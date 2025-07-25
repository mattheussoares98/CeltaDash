import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
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
      } else if (_currentSelectedParams.value?.enterpriseIds == null ||
          _currentSelectedParams.value!.enterpriseIds!.isEmpty) {
        throw DomainError.selectEnterprise;
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
  void changeSelectedEnterprise(int enterpriseId) {
    if (_currentSelectedParams.value == null) return;

    _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
      enterpriseIds: [enterpriseId],
    );
  }

  bool _isSelected({
    required CategoryGroupingType type,
    required CategoryGroupingType groupingValidating,
    required bool selected,
    CategoryGroupingType? doesntAffectCurrentValue,
  }) {
    if (type == groupingValidating) {
      return !selected;
    } else if (type == doesntAffectCurrentValue) {
      return selected;
    }

    return false;
  }

  @override
  void changeCategoryGroupingType(CategoryGroupingType type) {
    if (_currentSelectedParams.value == null) return;

    final oldParams = _currentSelectedParams.value;

    _currentSelectedParams.value = oldParams?.copyWith(
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
        selected: oldParams.groupByProductDepartment == true,
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
  bool changePeriodGroupingType(PeriodGroupingType type) {
    if (_currentSelectedParams.value == null) return false;

    final start = _currentSelectedParams.value?.startDate;
    final end = _currentSelectedParams.value?.endDate;
    int difference =
        start == null || end == null ? 0 : end.difference(start).inDays;

    try {
      mainError = null;
      if (type == PeriodGroupingType.year && difference < 366 ||
          type == PeriodGroupingType.month && difference < 32 ||
          type == PeriodGroupingType.day && difference < 1) {
        throw DomainError.shortPeriodSelected;
      }

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
      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
    }
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
