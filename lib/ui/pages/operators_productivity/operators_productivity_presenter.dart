import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../home/home.dart';

abstract class OperatorsProductivityPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<SaleMovementViewModel>? get saleMovements;

  Future<void> getSales(HomePresenter homePresenter);
}
