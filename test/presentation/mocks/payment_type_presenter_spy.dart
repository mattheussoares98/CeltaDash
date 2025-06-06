import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class PaymentTypePresenterSpy extends Mock implements PaymentTypePresenter {
  GetSalesParams? lastGetSalesParamsMock;

  PaymentTypePresenterSpy() {
    when(() => this.lastGetDailyParams)
        .thenAnswer((_) => lastGetSalesParamsMock);

    _mockGetSalesCall().thenAnswer((any) async => any);
  }

  When _mockGetSalesCall() => when(() => this.getSales(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ));

  void mockGetSalesError() {
    _mockGetSalesCall().thenThrow(DomainError.unexpected);
  }
}
