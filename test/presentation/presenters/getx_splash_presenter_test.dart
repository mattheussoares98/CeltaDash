import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

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

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseEntity();
  }

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

  test("Should navigate to login page if user is null", () async {
    EntityFactory.anullEnterpriseProperties(annullUser: true);
    
    await sut.checkPageToGo(durationInSeconds: 0);

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true));
  });
  test("Should navigate to login page if accessKey is null", () async {
    EntityFactory.anullEnterpriseProperties(annullAccessKey: true);

    await sut.checkPageToGo(durationInSeconds: 0);

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true));
  });
}
