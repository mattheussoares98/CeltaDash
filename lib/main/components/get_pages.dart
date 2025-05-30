import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../factories/factories.dart';

class GetPages {
  GetPages._();

  static Transition get transition =>
      !kIsWeb && Platform.isIOS ? Transition.cupertino : Transition.fadeIn;

  static final getPages = [
    GetPage(
      name: PageRoutes.compareDays,
      page: makeCompareDaysPage,
      transition: transition,
    ),
    GetPage(
      name: PageRoutes.more,
      page: makeMorePage,
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
      name: PageRoutes.operators,
      page: makeOperatorsPage,
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
      name: PageRoutes.sellers,
      page: makeSellersPage,
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
