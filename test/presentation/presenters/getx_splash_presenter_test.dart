import 'package:celta_plus/presentation/presenters/presenters.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';

void main() {
  // ignore: unused_local_variable
  late GetxSplashPresenter sut;

  late NavigateToSpy navigateTo;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxSplashPresenter(navigateTo: navigateTo);
  }

  void initEntitys() {}

  void initMockSuccess() {}

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });
}
