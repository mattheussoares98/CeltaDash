import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class OperatorsProductivityPresenterSpy extends Mock
    implements OperatorsProductivityPresenter {
  DateTime lastDateLoadedDataMock = DateTime.now();

  OperatorsProductivityPresenterSpy() {
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
