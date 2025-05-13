import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SalesPresenterSpy extends Mock implements SalesPresenter {
  DateTime lastDateLoadedDataMock = DateTime.now();
  bool filterByHourMock = false;
  bool filterByDayMock = false;
  bool filterByMonthMock = true;
  bool filterByYearMock = false;

  SalesPresenterSpy() {
    when(() => this.lastDateLoadedData)
        .thenAnswer((_) => lastDateLoadedDataMock);
    when(() => this.filterByHour).thenAnswer((_) => filterByHourMock);
    when(() => this.filterByDay).thenAnswer((_) => filterByDayMock);
    when(() => this.filterByMonth).thenAnswer((_) => filterByMonthMock);
    when(() => this.filterByYear).thenAnswer((_) => filterByYearMock);

    _mockGetSalesCall().thenAnswer((any) async => any);
    when(() => this.updateSelectedPeriod(
          filterByHour: any(named: 'filterByHour'),
          filterByDay: any(named: 'filterByDay'),
          filterByMonth: any(named: 'filterByMonth'),
          filterByYear: any(named: 'filterByYear'),
        )).thenAnswer((any) => any);
  }

  When _mockGetSalesCall() => when(() => this.getSales(
        homePresenter: any(named: 'homePresenter'),
        resumePresenter: any(named: 'resumePresenter'),
        forceRefresh: any(named: 'forceRefresh'),
      ));

  void mockGetSalesError() {
    _mockGetSalesCall().thenThrow(DomainError.unexpected);
  }
}
