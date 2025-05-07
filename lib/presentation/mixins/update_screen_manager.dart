import 'package:get/get.dart';

mixin UpdateScreenManager on GetxController {
  final _updateScreen = RxBool(false);

  set updateScreen(bool value) {
    if (_updateScreen.value != value) {
      _updateScreen.value = value;
    }
  }

  Stream<bool> get updateScreenStream => _updateScreen.stream;
}
