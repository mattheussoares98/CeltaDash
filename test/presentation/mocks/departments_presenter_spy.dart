import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class DepartmentsPresenterSpy extends Mock implements DepartmentsPresenter {
  GetSaleStatisticsParams? lastGetDailyParamsMock;
  GetSaleStatisticsParams? lastGetMonthlyParamsMock;

  DepartmentsPresenterSpy() {
    when(() => this.lastGetDailyParams)
        .thenAnswer((_) => lastGetDailyParamsMock);
    when(() => this.lastGetMonthlyParams)
        .thenAnswer((_) => lastGetMonthlyParamsMock);

    _mockGetSalesCall().thenAnswer((any) async => any);
  }

  When _mockGetSalesCall() => when(() => this.getSales(
        forceRefresh: any(named: 'forceRefresh'),
      ));

  void mockGetSalesError() {
    _mockGetSalesCall().thenThrow(DomainError.unexpected);
  }
}
