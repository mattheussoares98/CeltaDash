import 'package:flutter/material.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PersonalizedPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  PeriodGroupingType? get periodGroupingType;
  GetSaleStatisticsParams? get lastGetStatisticsParams;
  GetSaleStatisticsParams? get currentSelectedParams;
  DateTime? get startDate;
  DateTime? get endDate;

  void changeDateRange(DateTime? start, DateTime? end);
  void changeSelectedEnterprise(int enterpriseId);
  void changeCategoryGroupingType(CategoryGroupingType type);
  void changePeriodGroupingType(PeriodGroupingType type);

  Future<bool> getSales();
}
