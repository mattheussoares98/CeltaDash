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
      GetSaleStatisticsParams? params = _currentSelectedParams.value;

      if (params?.startDate == null || params?.endDate == null) {
        throw DomainError.selectPeriod;
      } else if (params?.enterpriseIds == null ||
          params!.enterpriseIds!.isEmpty) {
        throw DomainError.selectEnterprise;
      }

      final difference = params.endDate.difference(params.startDate).inDays;

      //large periods
      if (params.groupByHour == true && difference > 3 ||
          params.groupByDay == true && difference > 60) {
        mainError = UIError.custom(R.string.msgLongIntervalToGroupThisPeriod);
        return false;
      }

      final start = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
      );
      final end = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
      );
      if (end.isBefore(start)) {
        mainError = UIError.custom(R.string.msgEndDateBeforeStartDate);
        return false;
      }

      //products, departments or section cant group by period
      if (params.groupByProduct == true ||
          params.groupByProductDepartment == true ||
          params.groupByProductSection == true) {
        params = params.copyWith(
          groupByHour: false,
          groupByDay: false,
          groupByMonth: false,
          groupByYear: false,
          topCount: params.groupByProduct == true ? 300 : null,
        );
      }

      final sales = await loadSaleStatistics.get(params);

      saleStatistics = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      _lastGetStatisticsParams.value = params;
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
  void changeDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate != null) {
      _startDate = startDate;
    }

    if (endDate != null) {
      _endDate = endDate;
    }

    if (_startDate != null && _endDate != null) {
      _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
            startDate: _startDate,
            endDate: _endDate,
          ) ??
          GetSaleStatisticsParams(
            startDate: _startDate!,
            endDate: _endDate!,
          );
    }
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
  void changePeriodGroupingType(PeriodGroupingType type) {
    if (_currentSelectedParams.value == null) return;

    _currentSelectedParams.value = _currentSelectedParams.value?.copyWith(
      groupByYear: type == PeriodGroupingType.year,
      groupByMonth: type == PeriodGroupingType.month,
      groupByDay: type == PeriodGroupingType.day,
      groupByHour: type == PeriodGroupingType.hour,
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

  DateTime? _endDate;
  @override
  DateTime? get endDate => _endDate;

  DateTime? _startDate;
  @override
  DateTime? get startDate => _startDate;
}
