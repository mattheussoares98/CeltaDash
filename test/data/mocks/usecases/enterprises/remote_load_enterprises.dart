import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoadEnterprisesSpy extends Mock implements RemoteLoadEnterprises {
  RemoteLoadEnterprisesSpy() {
    this.mockGet();
  }

  When _mockGetCall() => when(() => this.get());

  void mockGet() {
    this._mockGetCall().thenAnswer((any) async => any);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
