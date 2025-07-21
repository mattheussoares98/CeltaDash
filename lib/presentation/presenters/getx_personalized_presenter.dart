import 'package:get/get.dart';

import '../../data/models/models.dart';
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

  @override
  Future<void> getSales(/* TODO add topCount param */) async {
    isLoading = true;
    mainError = null;
    try {
      if (startDate == null || endDate == null) {
        throw DomainError.selectPeriod; //TODO test
      }
      final sales = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: startDate!,
          endDate: endDate!,
          enterpriseIds: _enterprisesIds,
          groupByEnterprise: _nonExclusiveGroupingTypes
              .contains(NonExclusiveGroupingType.enterprise),
          groupByYear: _nonExclusiveGroupingTypes
              .contains(NonExclusiveGroupingType.year),
          groupByMonth: _nonExclusiveGroupingTypes
              .contains(NonExclusiveGroupingType.month),
          groupByDay:
              _nonExclusiveGroupingTypes.contains(NonExclusiveGroupingType.day),
          groupByHour: _nonExclusiveGroupingTypes
              .contains(NonExclusiveGroupingType.hour),
          groupByProduct:
              _exclusiveGroupingType == ExclusiveGroupingType.product,
          groupByProductDepartment:
              _exclusiveGroupingType == ExclusiveGroupingType.productDepartment,
          groupByProductSection:
              _exclusiveGroupingType == ExclusiveGroupingType.productSection,
          groupByPaymentFinalization: _exclusiveGroupingType ==
              ExclusiveGroupingType.paymentFinalization,
          groupByPaymentModality:
              _exclusiveGroupingType == ExclusiveGroupingType.paymentModality,
          groupByCashierOperator:
              _exclusiveGroupingType == ExclusiveGroupingType.cashierOperator,
          groupBySeller: _exclusiveGroupingType == ExclusiveGroupingType.seller,
          // topCount: ,
        ),
      );

      saleStatistics = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      //TODO add analytics
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
  void changeExclusiveGroupingType(ExclusiveGroupingType type) {
    if (_exclusiveGroupingType == type) {
      _exclusiveGroupingType = null;
    } else {
      _exclusiveGroupingType = type;
    }
  }

  @override
  void changeNonExclusiveGroupingType(NonExclusiveGroupingType type) {
    if (_nonExclusiveGroupingTypes.contains(type)) {
      _nonExclusiveGroupingTypes.remove(type);
    } else {
      _nonExclusiveGroupingTypes.add(type);
    }
  }

  DateTime? _endDate;
  @override
  DateTime? get endDate => _endDate;

  DateTime? _startDate;
  @override
  DateTime? get startDate => _startDate;

  final List<int> _enterprisesIds = [];
  @override
  List<int> get enterprisesIds => _enterprisesIds;

  ExclusiveGroupingType? _exclusiveGroupingType;
  @override
  ExclusiveGroupingType? get exclusiveGroupingType => _exclusiveGroupingType;

  final List<NonExclusiveGroupingType> _nonExclusiveGroupingTypes = [];
  @override
  List<NonExclusiveGroupingType> get nonExclusiveGroupingTypes =>
      _nonExclusiveGroupingTypes;
}
