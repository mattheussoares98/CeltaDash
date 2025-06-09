import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../presentation/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late HomePresenterSpy homePresenter;
  late PeriodType periodType;
  late GetSaleStatisticsParams lastGetSalesParams;

  void initUsecases() {}

  void initPresenters() {
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    homePresenter.selectedDateMock = faker.date.dateTime();
    periodType = PeriodType
        .values[faker.randomGenerator.integer(PeriodType.values.length)];
    lastGetSalesParams = EntityFactory.makeGetSalesParams();
  }

  void initMockSuccess() {}

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {});

  group("Can search", () {
    group("Pattern", () {
      test("Should return true if forceRefresh is true", () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: true,
          lastParams: null,
          selectedDate: homePresenter.selectedDateMock,
          periodType: periodType,
        );
        expect(value, true);
      });
      test("Should return true if lastGetSalesParams is null", () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: null,
          selectedDate: homePresenter.selectedDateMock,
          periodType: periodType,
        );

        expect(value, true);
      });
    });
    group("Daily", () {
      test("Should return false if is daily period and didnt change the date",
          () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastGetSalesParams,
          selectedDate: DateTime(
            lastGetSalesParams.startDate.year,
            lastGetSalesParams.startDate.month,
            lastGetSalesParams.startDate.day,
          ),
          periodType: PeriodType.daily,
        );

        expect(value, false);
      });
      test("Should return true if is daily period and changed the date", () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastGetSalesParams,
          selectedDate: faker.date.dateTime(),
          periodType: PeriodType.daily,
        );

        expect(value, true);
      });
      test(
          "Should return true if lastGetSalesParams days are different but endDate is equal firstDate",
          () {
        final lastParams = GetSaleStatisticsParams(
          startDate: homePresenter.selectedDateMock,
          endDate: homePresenter.selectedDateMock,
        );
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastParams,
          selectedDate: homePresenter.selectedDateMock.add(
            Duration(days: faker.randomGenerator.integer(30)),
          ),
          periodType: PeriodType.daily,
        );

        expect(value, true);
      });
    });
    group("Monthly", () {
      test("Should return false if is monthly period and didnt change the date",
          () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastGetSalesParams,
          selectedDate: DateTime(
            lastGetSalesParams.startDate.year,
            lastGetSalesParams.startDate.month,
            lastGetSalesParams.startDate.day,
          ),
          periodType: PeriodType.monthly,
        );

        expect(value, false);
      });
      test("Should return true if is monthly period and changed the date month",
          () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastGetSalesParams,
          selectedDate: lastGetSalesParams.startDate.add(Duration(days: 31)),
          periodType: PeriodType.monthly,
        );

        expect(value, true);
      });
      test("Should return true if start date is equal last date", () {
        final lastParams = GetSaleStatisticsParams(
          startDate: homePresenter.selectedDateMock,
          endDate: homePresenter.selectedDateMock,
        );
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastParams,
          selectedDate: homePresenter.selectedDateMock,
          periodType: PeriodType.monthly,
        );

        expect(value, true);
      });

      test("Should return false is getting sales from all year", () {
        final selectedDate = faker.date.dateTime();
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: GetSaleStatisticsParams(
            startDate: DateTime(selectedDate.year, 1, 1),
            endDate: DateTime(selectedDate.year, 12, 31),
          ),
          selectedDate: selectedDate,
          periodType: PeriodType.monthly,
        );

        expect(value, false);
      });
    });

    group("Yearly", () {
      test("Should return false if didnt change the selected year", () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastGetSalesParams,
          selectedDate: DateTime(lastGetSalesParams.startDate.year),
          periodType: PeriodType.yearly,
        );

        expect(value, false);
      });
      test("Should return true if change the selected year", () {
        final value = StatisticsHelper.canSearch(
          forceRefresh: false,
          lastParams: lastGetSalesParams,
          selectedDate: DateTime(lastGetSalesParams.startDate.year +
              faker.randomGenerator.integer(999)),
          periodType: PeriodType.yearly,
        );

        expect(value, true);
      });
    });
  });
}
