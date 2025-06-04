import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GetPlatformTypeSpy extends Mock implements GetPlatformType {
  When _mockGetCall() => when(() => this.get());

  void mockGet(PlatformType platform) {
    this._mockGetCall().thenAnswer((any) => platform);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
