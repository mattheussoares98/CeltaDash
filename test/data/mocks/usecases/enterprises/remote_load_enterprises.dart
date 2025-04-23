import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoadEnterprisesSpy extends Mock implements RemoteLoadEnterprises {
  When _mockGetCall() => when(() => this.get());

  void mockGet(SoapResponseModel response) {
    this._mockGetCall().thenAnswer((any) async => response);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
