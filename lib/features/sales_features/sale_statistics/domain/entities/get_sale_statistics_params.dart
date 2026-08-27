// lib/features/sale_statistics/domain/entities/get_sale_statistics_params.dart
import 'package:equatable/equatable.dart';

class GetSaleStatisticsParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final List<int>? enterpriseIds;
  final bool? groupByEnterprise;
  final bool? groupByYear;
  final bool? groupByMonth;
  final bool? groupByDay;
  final bool? groupByHour;
  final bool? groupByProduct;
  final bool? groupByProductDepartment;
  final bool? groupByProductSection;
  final bool? groupByPaymentFinalization;
  final bool? groupByPaymentModality;
  final bool? groupByCashierOperator;
  final bool? groupBySeller;
  final int? topCount;

  const GetSaleStatisticsParams({
    required this.startDate,
    required this.endDate,
    this.enterpriseIds,
    this.groupByEnterprise,
    this.groupByYear,
    this.groupByMonth,
    this.groupByDay,
    this.groupByHour,
    this.groupByProduct,
    this.groupByProductDepartment,
    this.groupByProductSection,
    this.groupByPaymentFinalization,
    this.groupByPaymentModality,
    this.groupByCashierOperator,
    this.groupBySeller,
    this.topCount,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        enterpriseIds,
        groupByEnterprise,
        groupByYear,
        groupByMonth,
        groupByDay,
        groupByHour,
        groupByProduct,
        groupByProductDepartment,
        groupByProductSection,
        groupByPaymentFinalization,
        groupByPaymentModality,
        groupByCashierOperator,
        groupBySeller,
        topCount,
      ];

  GetSaleStatisticsParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<int>? enterpriseIds,
    bool? groupByEnterprise,
    bool? groupByYear,
    bool? groupByMonth,
    bool? groupByDay,
    bool? groupByHour,
    bool? groupByProduct,
    bool? groupByProductDepartment,
    bool? groupByProductSection,
    bool? groupByPaymentFinalization,
    bool? groupByPaymentModality,
    bool? groupByCashierOperator,
    bool? groupBySeller,
    int? topCount,
  }) {
    return GetSaleStatisticsParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      enterpriseIds: enterpriseIds ?? this.enterpriseIds,
      groupByEnterprise: groupByEnterprise ?? this.groupByEnterprise,
      groupByYear: groupByYear ?? this.groupByYear,
      groupByMonth: groupByMonth ?? this.groupByMonth,
      groupByDay: groupByDay ?? this.groupByDay,
      groupByHour: groupByHour ?? this.groupByHour,
      groupByProduct: groupByProduct ?? this.groupByProduct,
      groupByProductDepartment:
          groupByProductDepartment ?? this.groupByProductDepartment,
      groupByProductSection:
          groupByProductSection ?? this.groupByProductSection,
      groupByPaymentFinalization:
          groupByPaymentFinalization ?? this.groupByPaymentFinalization,
      groupByPaymentModality:
          groupByPaymentModality ?? this.groupByPaymentModality,
      groupByCashierOperator:
          groupByCashierOperator ?? this.groupByCashierOperator,
      groupBySeller: groupBySeller ?? this.groupBySeller,
      topCount: topCount ?? this.topCount,
    );
  }

  Map<String, dynamic> toBody() => {
        "enterpriseIds": enterpriseIds,
        "topCount": topCount,
        "period": {
          "startDate": startDate.toIso8601String(),
          "endDate": endDate.toIso8601String(),
        },
        "groupByEnterprise": groupByEnterprise == true,
        "groupByYear": groupByYear == true,
        "groupByMonth": groupByMonth == true,
        "groupByDay": groupByDay == true,
        "groupByHour": groupByHour == true,
        "groupByProduct": groupByProduct == true,
        "groupByProductDepartment": groupByProductDepartment == true,
        "groupByProductSection": groupByProductSection == true,
        "groupByPaymentFinalization": groupByPaymentFinalization == true,
        "groupByPaymentModality": groupByPaymentModality == true,
        "groupByCashierOperator": groupByCashierOperator == true,
        "groupBySeller": groupBySeller == true,
      };
}
