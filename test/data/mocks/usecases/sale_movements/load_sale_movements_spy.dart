import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleMovementsSpy extends Mock implements LoadSaleMovements {
  When _mockGetCall() => when(
        () => this.get(any()),
      );

  void mockGet(List<SaleMovementEntity> saleMovements) {
    this._mockGetCall().thenAnswer((any) async => saleMovements);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
