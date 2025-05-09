import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SalesPresenter implements Listenable {
  List<SaleMovementViewModel>? get saleMovements;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get lastLoadedDate;

  Future<void> getSales({
    required HomePresenter homePresenter,
    bool? searchByHour,
    bool? searchByDay,
    bool? searchByMonth,
    bool? searchByYear,
    bool? forceRefresh,
  });
}
