import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class OperatorsPresenterSpy extends Mock
    implements OperatorsPresenter {
  DateTime lastDateLoadedDataMock = DateTime.now();

  OperatorsPresenterSpy() {
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
