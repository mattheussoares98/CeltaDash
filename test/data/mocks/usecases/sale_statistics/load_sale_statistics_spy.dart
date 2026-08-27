import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleMovementsSpy extends Mock implements LoadSaleMovements {
  When _mockGetCall() => when(() => this.get(any()));

  void mockGet(SaleMovementEntity saleMovement) {
    this._mockGetCall().thenAnswer((any) async => saleMovement);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
