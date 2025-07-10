import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadDeviceDataSpy extends Mock implements LoadDeviceData {
  When _mockGetAppVersionCall() => when(() => this.getAppVersion());

  void mockGetAppVersion(String version) {
    this._mockGetAppVersionCall().thenAnswer((any) async => version);
  }

  void mockGetAppVersionError() {
    this._mockGetAppVersionCall().thenThrow(Exception());
  }
}
