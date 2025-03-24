import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../factories/factories.dart';

class GetPages {
  GetPages._();

  static final getPages = [
    GetPage(
      name: PageRoutes.compareDays,
      page: makeCompareDaysPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.goalHistory,
      page: makeGoalHistoryPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.groupSummary,
      page: makeGroupSummaryPage,
      transition: Transition.fadeIn,
    ),
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
      name: PageRoutes.paymentsType,
      page: makePaymentsTypePage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.profitability,
      page: makeProfitabilityPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.sections,
      page: makeSectionsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.setGoal,
      page: makeSetGoalPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.splash,
      page: makeSplashPage,
      transition: Transition.fadeIn,
    ),
  ];
}
