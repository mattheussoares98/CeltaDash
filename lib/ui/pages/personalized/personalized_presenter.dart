import 'package:flutter/material.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PersonalizedPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get startDate;
  DateTime? get endDate;

  void changeSelectedDateRange(DateTime start, DateTime end);

  Future<void> getSales({
    required DateTime startDate,
    required DateTime endDate,
    required List<int>? enterpriseIds,
    required bool? groupByEnterprise,
    required bool? groupByYear,
    required bool? groupByMonth,
    required bool? groupByDay,
    required bool? groupByHour,
    required bool? groupByProduct,
    required bool? groupByProductDepartment,
    required bool? groupByProductSection,
    required bool? groupByPaymentFinalization,
    required bool? groupByPaymentModality,
    required bool? groupByCashierOperator,
    required bool? groupBySeller,
    required int? topCount,
  });
}
