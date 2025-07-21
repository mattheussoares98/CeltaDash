import 'package:flutter/material.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PersonalizedPresenter implements Listenable {
  List<SaleStatisticViewModel>? get saleStatistics;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
}
