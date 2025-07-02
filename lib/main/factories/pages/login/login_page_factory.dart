import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

LoginPage makeLoginPage() {
  Get.put<EnterprisesManagerPresenter>(makeGetxEnterprisesManagerPresenter());

  return LoginPage(presenter: makeGetxLoginPresenter());
}
