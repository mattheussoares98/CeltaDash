import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import '../../../../ui/services/services.dart';
import '../../factories.dart';

HomePage makeHomePage() {
  Get.put<AppAnalyticsService>(makeGetxAppAnalyticsService());
  Get.replace<HomePresenter>(makeGetxHomePresenter());
  Get.replace<BsSalesPresenter>(makeGetxBsSalesPresenter());
  Get.replace<CompareDaysPresenter>(makeGetxCompareDaysPresenter());
  Get.replace<CompareMonthsPresenter>(makeGetxCompareMonthsPresenter());
  Get.replace<DepartmentsPresenter>(makeGetxDepartmentsPresenter());
  Get.replace<FinancialTitlesPresenter>(makeFinancialTitlesPresenter());
  Get.replace<PaymentTypePresenter>(makeGetxPaymentTypePresenter());
  Get.replace<ProductsPresenter>(makeGetxProductsPresenter());
  Get.replace<ResumePresenter>(makeGetxResumePresenter());
  Get.replace<SalesPresenter>(makeGetxSalesPresenter());
  Get.replace<SellersPresenter>(makeGetxSellersPresenter());
  Get.replace<OperatorsPresenter>(makeGetxOperatorsPresenter());
  Get.put<EnterprisesManagerPresenter>(makeGetxEnterprisesManagerPresenter());

  return const HomePage();
}
