import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../home/home.dart';

abstract class OperatorsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleMovementViewModel>? get saleMovements;
  DateTime? get lastDateLoadedData;

  Future<void> getSales(HomePresenter homePresenter, {bool? forceRefresh});
  void emitLoadingAgain();
}
