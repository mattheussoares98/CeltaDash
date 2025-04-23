import 'dart:convert';

import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late GetxHomePresenter sut;

  late NavigateToSpy navigateTo;
  late RemoteLoadEnterprisesSpy remoteLoadEnterprises;

  late SoapResponseModel soapResponse;
  late List<BsEnterpriseEntity> bsEnterprises;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    remoteLoadEnterprises = RemoteLoadEnterprisesSpy();
  }

  void initPresenters() {
    sut = GetxHomePresenter(
      navigateTo: navigateTo,
      remoteLoadEnterprises: remoteLoadEnterprises,
    );
  }

  void initEntities() {
    bsEnterprises = [
      EntityFactory.makeBsEnterpriseEntity(),
      EntityFactory.makeBsEnterpriseEntity(),
    ];
    soapResponse = SoapResponseModel(
      response: json.encode(
        bsEnterprises
            .map((e) => BsEnterpriseModel.fromEntity(e).toJson())
            .toList(),
      ),
      responseType: SoapResponseType.success,
    );
  }

  void initMockSuccess() {
    remoteLoadEnterprises.mockGet(soapResponse);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });

  group("Change page index", () {
    test("Should update current index correctly", () {
      final first = faker.randomGenerator.integer(100);
      final second = faker.randomGenerator.integer(100);
      final third = faker.randomGenerator.integer(100);
      expectLater(
        sut.currentPageIndexStream,
        emitsInOrder([first, second, third]),
      );

      sut.updateSelectedIndex(first);
      sut.updateSelectedIndex(first);
      sut.updateSelectedIndex(second);
      sut.updateSelectedIndex(second);
      sut.updateSelectedIndex(third);
      sut.updateSelectedIndex(third);
    });
  });

  group("Update selected date", () {
    test("Should update date correctly", () {
      final firstDate = faker.date.dateTime();
      final secondDate = faker.date.dateTime();

      sut.updateSelectedDate(firstDate);
      expect(sut.selectedDate, firstDate);

      sut.updateSelectedDate(secondDate);
      expect(sut.selectedDate, secondDate);
    });
  });

  group("Navigation", () {
    test("Should go to configurations page", () {
      sut.goToConfigurationsPage();

      verify(
        () => navigateTo.navigate(
            pageRoute: PageRoutes.configurations, clear: false),
      ).called(1);
    });
  });

  group("Get enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.bsEnterprisesStream, emits(bsEnterprises));

      await sut.getBsEnterprises(showBsErrorMessage: (_) {});
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      remoteLoadEnterprises.mockGetError();

      await sut.getBsEnterprises(showBsErrorMessage: (_) {});
    });

    test("Should call remoteLoadEnterprises", () async {
      await sut.getBsEnterprises(showBsErrorMessage: (_) {});

      verify(() => remoteLoadEnterprises.get()).called(1);
    });
  });
}
