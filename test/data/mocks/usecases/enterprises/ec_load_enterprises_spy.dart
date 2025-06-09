import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class EcLoadEnterprisesSpy extends Mock implements EcLoadEnterprises {
  When _mockGetCall() => when(() => this.get(
        url: any(named: "url"),
        accessKey: any(named: "accessKey"),
        userName: any(named: "userName"),
      ));

  void mockGet(List<EcEnterpriseEntity> entities) {
    this._mockGetCall().thenAnswer((any) async => entities);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
