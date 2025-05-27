import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

HomePage makeHomePage() {
  Get.replace<DepartmentsPresenter>(makeGetxDepartmentsPresenter());
  Get.replace<HomePresenter>(makeGetxHomePresenter());
  Get.replace<PaymentTypePresenter>(makeGetxPaymentTypePresenter());
  Get.replace<ProductsPresenter>(makeGetxProductsPresenter());
  Get.replace<ResumePresenter>(makeGetxResumePresenter());
  Get.replace<SalesPresenter>(makeGetxSalesPresenter());
  Get.replace<OperatorsProductivityPresenter>(
    makeGetxOperatorsProductivityPresenter(),
  );

  return HomePage();
}
