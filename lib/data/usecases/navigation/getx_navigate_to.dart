import 'package:get/get.dart';

import '../../../domain/usecases/usecases.dart';

class GetxNavigateTo implements NavigateTo {
  @override
  Future<dynamic> navigate({
    required String pageRoute,
    bool? clear = false,
  }) async {
    if (clear == true) {
      return await Get.offAllNamed(pageRoute);
    } else {
      return await Get.toNamed(pageRoute);
    }
  }

  @override
  void closePage() {
    Get.back();
  }
}
