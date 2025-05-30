import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxTeamPresenter extends GetxController implements TeamPresenter {
  final NavigateTo navigateTo;

  GetxTeamPresenter({required this.navigateTo});

  @override
  void goToOperatorsChargeBacksPage() {
    navigateTo.navigate(pageRoute: PageRoutes.operatorsChargeBacks);
  }

  @override
  void goToOperatorsDiscountsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.operatorsDiscounts);
  }

  @override
  void goToOperatorsProductivityPage() {
    navigateTo.navigate(pageRoute: PageRoutes.operatorsProductivity);
  }

  @override
  void goToOperatorsSalesPage() {
    navigateTo.navigate(pageRoute: PageRoutes.operatorsSales);
  }

  @override
  void goToSellersSalesPage() {
    navigateTo.navigate(pageRoute: PageRoutes.sellers);
  }
}
