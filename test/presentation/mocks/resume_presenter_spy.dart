import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class ResumePresenterSpy extends Mock implements ResumePresenter {
  DateTime lastDateLoadedDataMock = DateTime.now();

  ResumePresenterSpy() {
    when(() => this.lastDateLoadedData)
        .thenAnswer((_) => lastDateLoadedDataMock);

    when(() => this.goToProfitabillityPage()).thenAnswer((any) => any);
    when(() => this.goToCompareDays()).thenAnswer((any) => any);
    when(() => this.goToDepartmentsPage()).thenAnswer((any) => any);
    when(() => this.goToPaymentsTypePage()).thenAnswer((any) => any);
    when(() => this.goToSetGoalPage()).thenAnswer((any) => any);
    when(() => this.goToGoalHistoryPage()).thenAnswer((any) => any);
    when(() => this.goToGroupSummaryPage()).thenAnswer((any) => any);
    this._mockGetSalesCall().thenAnswer((any) async => any);
  }

  When _mockGetSalesCall() => when(
      () => this.getSales(any(), forceRefresh: any(named: "forceRefresh")));
  void mockGetSalesError() {
    this._mockGetSalesCall().thenThrow(DomainError.unexpected);
  }
}
