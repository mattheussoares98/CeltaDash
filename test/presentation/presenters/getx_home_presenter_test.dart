import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  // ignore: unused_local_variable
  late GetxHomePresenter sut;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {}

  void initPresenters() {
    sut = GetxHomePresenter();
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
}
