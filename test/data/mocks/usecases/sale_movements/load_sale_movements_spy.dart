import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleStatisticsSpy extends Mock implements LoadSaleStatistics {
  LoadSaleStatisticsSpy() {
    registerFallbackValue(
      GetSaleStatisticsParams(
        startDate: DateTime(2020),
        endDate: DateTime(2020),
      ),
    );
  }

  When _mockGetCall() => when(() => this.get(any()));

  void mockGet(List<SaleStatisticsEntity> saleStatistics) {
    this._mockGetCall().thenAnswer((any) async => saleStatistics);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
