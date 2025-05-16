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
      name: PageRoutes.configurations,
      page: makeConfigurationsPage,
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
      name: PageRoutes.operatorsChargeBacks,
      page: makeOperatorsChargeBacksPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.operatorsDiscounts,
      page: makeOperatorsDiscountsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.operatorsProductivity,
      page: makeOperatorsProductivityPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.operatorsSales,
      page: makeOperatorsSalesPage,
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
      name: PageRoutes.sallersSales,
      page: makeSallersSalesPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.departments,
      page: makeDepartmentsPage,
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
    GetPage(
      name: PageRoutes.splash,
      page: makeTeamPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.webEnterpriseDetails,
      page: makeWebEnterpriseDetailsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.webEnterprises,
      page: makeWebEnterprisesPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.webLogin,
      page: makeWebLoginPage,
      transition: Transition.fadeIn,
    ),
  ];
}
