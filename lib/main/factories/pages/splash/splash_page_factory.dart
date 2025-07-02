import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SplashPage makeSplashPage() {
  Get.put<EnterprisesManagerPresenter>(makeGetxEnterprisesManagerPresenter());

  return SplashPage(presenter: makeGetxSplashPresenter());
}
