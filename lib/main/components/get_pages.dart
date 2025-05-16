import 'dart:io';

import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../factories/factories.dart';

class GetPages {
  GetPages._();

  static Transition get transition =>
      Platform.isIOS ? Transition.cupertino : Transition.fadeIn;

  static final getPages = [
    GetPage(
      name: PageRoutes.compareDays,
      page: makeCompareDaysPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.configurations,
      page: makeConfigurationsPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.goalHistory,
      page: makeGoalHistoryPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.groupSummary,
      page: makeGroupSummaryPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.home,
      page: makeHomePage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.login,
      page: makeLoginPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.operatorsChargeBacks,
      page: makeOperatorsChargeBacksPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.operatorsDiscounts,
      page: makeOperatorsDiscountsPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.operatorsProductivity,
      page: makeOperatorsProductivityPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.operatorsSales,
      page: makeOperatorsSalesPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.paymentsType,
      page: makePaymentsTypePage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.profitability,
      page: makeProfitabilityPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.sallersSales,
      page: makeSallersSalesPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.departments,
      page: makeDepartmentsPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.setGoal,
      page: makeSetGoalPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.splash,
      page: makeSplashPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.splash,
      page: makeTeamPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.webEnterpriseDetails,
      page: makeWebEnterpriseDetailsPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.webEnterprises,
      page: makeWebEnterprisesPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.webLogin,
      page: makeWebLoginPage,
      transition: transition,
    ),
  ];
}
