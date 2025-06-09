import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SalesPresenterSpy extends Mock implements SalesPresenter {
  GetEcSaleStatisticsParams? get lastGetSalesParamsMock;

  SalesPresenterSpy() {
    when(() => this.lastGetDailyParams)
        .thenAnswer((_) => lastGetSalesParamsMock);

    _mockGetSalesCall().thenAnswer((any) async => any);
  }

  When _mockGetSalesCall() => when(() => this.getSales(
        any(),
        periodType: any(named: 'periodType'),
        forceRefresh: any(named: 'forceRefresh'),
      ));

  void mockGetSalesError() {
    _mockGetSalesCall().thenThrow(DomainError.unexpected);
  }
}
