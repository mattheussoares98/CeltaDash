import 'package:get/get.dart';

void mockNavigation({
  required String routeName,
  bool? clear = false,
  dynamic arguments,
}) {
  if (clear == true) {
    Get.offAllNamed(routeName, arguments: arguments);
  } else {
    Get.toNamed(routeName, arguments: arguments);
  }
}
