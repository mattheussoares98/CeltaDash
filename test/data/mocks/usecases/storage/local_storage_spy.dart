import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LocalStorageSpy extends Mock implements LocalStorage {
  LocalStorageSpy() {
    this.mockDelete();
  }

  When _mockGetCall() => when(() => this.get(any()));
  void mockGet(dynamic value) {
    this._mockGetCall().thenAnswer((any) async => value);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }

  When _mockPutCall<T>() => when(() => put<T>(any(), any()));

  void mockPut<T>(T insertTheGenerics) {
    _mockPutCall<T>().thenAnswer((any) async => any);
  }

  void mockPutError() {
    this._mockPutCall().thenThrow(Exception());
  }

  When _mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() {
    this._mockDeleteCall().thenAnswer((any) async => any);
  }

  void mockDeleteError() {
    this._mockDeleteCall().thenThrow(Exception());
  }
}
