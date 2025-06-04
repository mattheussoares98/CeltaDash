import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleMovementsSpy extends Mock implements LoadSaleMovements {
  When _mockGetCall() => when(
        () => this.get(
          startDate: any(named: "startDate"),
          endDate: any(named: "endDate"),
          enterpriseIds: any(named: "enterpriseIds"),
          topCount: any(named: "topCount"),
          groupByDay: any(named: "groupByDay"),
          groupByEnterprise: any(named: "groupByEnterprise"),
          groupByHour: any(named: "groupByHour"),
          groupByMonth: any(named: "groupByMonth"),
          groupByYear: any(named: "groupByYear"),
          groupByPaymentFinalization: any(named: "groupByPaymentFinalization"),
          groupByPaymentModality: any(named: "groupByPaymentModality"),
          groupByProduct: any(named: "groupByProduct"),
          groupByProductDepartment: any(named: "groupByProductDepartment"),
          groupByProductSection: any(named: "groupByProductSection"),
          groupByCashierOperator: any(named: "groupByCashierOperator"),
          groupBySeller: any(named: "groupBySeller"),
        ),
      );

  void mockGet(List<SaleMovementEntity> saleMovements) {
    this._mockGetCall().thenAnswer((any) async => saleMovements);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
