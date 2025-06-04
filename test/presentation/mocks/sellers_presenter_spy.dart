import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SellersPresenterSpy extends Mock implements SellersPresenter {
  DateTime lastDateLoadedDataMock = DateTime.now();

  SellersPresenterSpy() {
    when(() => this.lastDateLoadedData)
        .thenAnswer((_) => lastDateLoadedDataMock);

    _mockGetSalesCall().thenAnswer((any) async => any);
    when(() => this.emitLoadingAgain()).thenAnswer((any) async => any);
  }

  When _mockGetSalesCall() => when(() => this.getSales(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ));

  void mockGetSalesError() {
    _mockGetSalesCall().thenThrow(DomainError.unexpected);
  }
}
