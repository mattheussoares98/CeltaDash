import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class EcLoadSaleStatisticsSpy extends Mock implements EcLoadSaleStatistics {
  When _mockGetCall() => when(
        () => this.get(any()),
      );

  void mockGet(List<SaleStatisticsEntity> saleStatistics) {
    this._mockGetCall().thenAnswer((any) async => saleStatistics);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
