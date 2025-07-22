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
  ExclusiveGroupingType? get exclusiveGroupingType;
  List<NonExclusiveGroupingType> get nonExclusiveGroupingTypes;

  void changeDateRange(DateTime start, DateTime end);
  void changeEnterpriseIds(int enterpriseId);
  void changeExclusiveGroupingType(ExclusiveGroupingType type);
  void changeNonExclusiveGroupingType(NonExclusiveGroupingType type);
  void selectAllEnterprises();

  Future<void> getSales();
}
