import 'package:celta_plus/data/database/database.dart';
import 'package:mocktail/mocktail.dart';

class HiveStorageSpy extends Mock implements HiveStorage {
  HiveStorageSpy() {
    this.mockDelete();
    this.mockPut();
    this.mockGet(null);
  }
  When _mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() {
    this._mockDeleteCall().thenAnswer((any) async => any);
  }

  void mockDeleteError() {
    this._mockDeleteCall().thenThrow(Exception());
  }

  When _mockPutCall() => when(() => this.put(any(), any()));
  void mockPut() {
    this._mockPutCall().thenAnswer((any) async => any);
  }

  void mockPutError() {
    this._mockPutCall().thenThrow(Exception());
  }

  When _mockGetCall() => when(() => this.get(any()));
  void mockGet(dynamic value) {
    this._mockGetCall().thenAnswer((any) async => value);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
