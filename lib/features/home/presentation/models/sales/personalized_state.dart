// lib/features/home/presentation/models/personalized_state.dart
import 'package:celta_dash/core/domain/helpers/helpers.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PersonalizedState extends Equatable {
  const PersonalizedState({
    required this.startDate,
    required this.endDate,
    required this.selectedEnterpriseId,
    required this.periodGrouping,
    required this.categoryGroupings,
    required this.sales,
    required this.validationError,
    required this.lastLoadedParams,
  });

  factory PersonalizedState.initial() => const PersonalizedState(
    startDate: null,
    endDate: null,
    selectedEnterpriseId: null,
    periodGrouping: null,
    categoryGroupings: {},
    sales: AsyncValue.data([]),
    validationError: null,
    lastLoadedParams: null,
  );

  final DateTime? startDate;
  final DateTime? endDate;
  final int? selectedEnterpriseId;
  final PeriodGroupingType? periodGrouping;
  final Set<CategoryGroupingType> categoryGroupings;
  final AsyncValue<List<SaleStatisticsEntity>> sales;
  final String? validationError;
  final GetSaleStatisticsParams? lastLoadedParams;

  bool get hasValidDateRange => startDate != null && endDate != null;
  bool get canGenerate => hasValidDateRange && selectedEnterpriseId != null;
  bool get isGenerating => sales.isLoading;

  GetSaleStatisticsParams? buildParams() {
    if (startDate == null || endDate == null || selectedEnterpriseId == null) {
      return null;
    }

    final hasProduct = categoryGroupings.contains(CategoryGroupingType.product);
    final hasDepartment = categoryGroupings.contains(
      CategoryGroupingType.productDepartment,
    );
    final hasSection = categoryGroupings.contains(
      CategoryGroupingType.productSection,
    );
    final disablePeriod = hasProduct || hasDepartment || hasSection;

    return GetSaleStatisticsParams(
      startDate: startDate!,
      endDate: endDate!,
      enterpriseIds: [selectedEnterpriseId!],
      groupByYear: disablePeriod
          ? false
          : periodGrouping == PeriodGroupingType.year,
      groupByMonth: disablePeriod
          ? false
          : periodGrouping == PeriodGroupingType.month,
      groupByDay: disablePeriod
          ? false
          : periodGrouping == PeriodGroupingType.day,
      groupByHour: disablePeriod
          ? false
          : periodGrouping == PeriodGroupingType.hour,
      groupByProduct: hasProduct,
      groupByProductDepartment: hasDepartment,
      groupByProductSection: hasSection,
      groupByPaymentFinalization: categoryGroupings.contains(
        CategoryGroupingType.paymentFinalization,
      ),
      groupByPaymentModality: categoryGroupings.contains(
        CategoryGroupingType.paymentModality,
      ),
      groupByCashierOperator: categoryGroupings.contains(
        CategoryGroupingType.cashierOperator,
      ),
      groupBySeller: categoryGroupings.contains(CategoryGroupingType.seller),
      topCount: hasProduct ? 300 : null,
    );
  }

  PersonalizedState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? selectedEnterpriseId,
    PeriodGroupingType? periodGrouping,
    Set<CategoryGroupingType>? categoryGroupings,
    AsyncValue<List<SaleStatisticsEntity>>? sales,
    String? validationError,
    GetSaleStatisticsParams? lastLoadedParams,
    bool clearSelectedEnterpriseId = false,
    bool clearPeriodGrouping = false,
    bool clearValidationError = false,
    bool clearLastLoadedParams = false,
  }) {
    return PersonalizedState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedEnterpriseId: clearSelectedEnterpriseId
          ? null
          : selectedEnterpriseId ?? this.selectedEnterpriseId,
      periodGrouping: clearPeriodGrouping
          ? null
          : periodGrouping ?? this.periodGrouping,
      categoryGroupings: categoryGroupings ?? this.categoryGroupings,
      sales: sales ?? this.sales,
      validationError: clearValidationError
          ? null
          : validationError ?? this.validationError,
      lastLoadedParams: clearLastLoadedParams
          ? null
          : lastLoadedParams ?? this.lastLoadedParams,
    );
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    selectedEnterpriseId,
    periodGrouping,
    categoryGroupings,
    sales,
    validationError,
    lastLoadedParams,
  ];
}
