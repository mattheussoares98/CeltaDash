import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CompareDaysPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  DateTime? get selectedFirstDay;
  DateTime? get selectedSecondDay;

  Future<void> getSales({
    required DateTime? firstDay,
    required DateTime? secondDay,
    required HomePresenter homePresenter,
  });
}
