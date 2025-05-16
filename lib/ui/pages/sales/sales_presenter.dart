import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovementsByMonth;
  List<SaleMovementViewModel>? get saleMovementsByYear;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get lastDateLoadedData;
  EnterpriseViewModel? get lastEnterpriseLoadedData;

  bool get filterByHour;
  bool get filterByDay;
  bool get filterByMonth;
  bool get filterByYear;

  Future<void> getSales({
    required HomePresenter homePresenter,
    required ResumePresenter resumePresenter,
    bool? forceRefresh,
  });

  void updateSelectedPeriod({
    bool? filterByHour,
    bool? filterByDay,
    bool? filterByMonth,
    bool? filterByYear,
  });

  void clear();
}
