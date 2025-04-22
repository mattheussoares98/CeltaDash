import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleMovementsSpy extends Mock implements LoadSaleMovements {
  LoadSaleMovementsSpy() {
    this.mockGet();
  }

  When _mockGetCall() => when(
        () => this.get(
          startDate: any(named: "startDate"),
          endDate: any(named: "endDate"),
          enterpriseIds: any(named: "enterpriseIds"),
          groupByDay: any(named: "groupByDay"),
          groupByEnterprise: any(named: "groupByEnterprise"),
          groupByHour: any(named: "groupByHour"),
          groupByMonth: any(named: "groupByMonth"),
          groupByPaymentFinalization: any(named: "groupByPaymentFinalization"),
          groupByPaymentModality: any(named: "groupByPaymentModality"),
          groupByProduct: any(named: "groupByProduct"),
          groupByProductDepartment: any(named: "groupByProductDepartment"),
          groupByProductSection: any(named: "groupByProductSection"),
        ),
      );

  void mockGet() {
    this._mockGetCall().thenAnswer((any) async => any);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
