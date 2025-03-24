import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../factories/factories.dart';

class GetPages {
  GetPages._();

  static final getPages = [
    GetPage(
      name: PageRoutes.home,
      page: makeHomePage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.login,
      page: makeLoginPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.profitability,
      page: makeProfitabilityPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.splash,
      page: makeSplashPage,
      transition: Transition.fadeIn,
    ),
  ];
}
