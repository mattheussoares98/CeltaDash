import 'package:flutter/material.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PersonalizedPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get startDate;
  DateTime? get endDate;
  List<int> get enterprisesIds;
  List<CategoryGroupingType> get categoryGroupingTypes;
  PeriodGroupingType? get periodGroupingType;
  GetSaleStatisticsParams? get lastGetStatisticsParams;
  GetSaleStatisticsParams? get currentSelectedParams;

  void changeDateRange(DateTime start, DateTime end);
  void changeEnterpriseIds(int enterpriseId);
  void changeCategoryGroupingType(CategoryGroupingType type);
  void changePeriodGroupingType(PeriodGroupingType type);
  void selectAllEnterprises();

  Future<bool> getSales();
}
