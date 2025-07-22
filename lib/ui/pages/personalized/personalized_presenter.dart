import 'package:flutter/material.dart';
import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PersonalizedPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get startDate;
  DateTime? get endDate;
  List<int> get enterprisesIds;
  CategoryGroupingType? get categoryGroupingType;
  List<PeriodGroupingType> get periodGroupingTypes;

  void changeDateRange(DateTime start, DateTime end);
  void changeEnterpriseIds(int enterpriseId);
  void changeExclusiveGroupingType(CategoryGroupingType type);
  void changePeriodGroupingType(PeriodGroupingType type);
  void selectAllEnterprises();

  Future<void> getSales();
}
