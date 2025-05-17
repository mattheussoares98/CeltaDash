import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadEnterprisesSpy extends Mock implements LoadEnterprises {
  When _mockGetCall() => when(() => this.get(url: any(named: "url")));

  void mockGet(List<EnterpriseEntity> entities) {
    this._mockGetCall().thenAnswer((any) async => entities);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
