import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GetPlatformTypeSpy extends Mock implements GetPlatformType {
  When _mockGetCall() => when(() => this.get());

  void mockGet(PlatformType platform) {
    this._mockGetCall().thenAnswer((any) async => platform);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
