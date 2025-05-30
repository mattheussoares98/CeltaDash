import 'package:flutter/widgets.dart';

abstract class TeamPresenter implements Listenable {
  void goToOperatorsDiscountsPage();
  void goToOperatorsChargeBacksPage();
  void goToOperatorsProductivityPage();
  void goToOperatorsSalesPage();
  void goToSellersSalesPage();
}
