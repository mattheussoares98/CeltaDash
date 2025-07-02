import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class LocalStorageSpy extends Mock implements LocalStorage {
  LocalStorageSpy() {
    this._mockDelete();
    this._mockPut();
  }

  When _mockGetCall(DatabaseKeys key) => when(() => this.get(key));
  void mockGet(DatabaseKeys key, dynamic value) {
    this._mockGetCall(key).thenAnswer((any) async => value);
  }

  void mockGetError(DatabaseKeys key) {
    this._mockGetCall(key).thenThrow(Exception());
  }

  When _mockPutCall() => when(() => put(any(), any()));
  void _mockPut() {
    _mockPutCall().thenAnswer((_) async {});
  }

  void mockPutError() {
    _mockPutCall().thenThrow(Exception());
  }

  When _mockDeleteCall() => when(() => delete(any()));
  void _mockDelete() {
    _mockDeleteCall().thenAnswer((_) async {});
  }

  void mockDeleteError() {
    _mockDeleteCall().thenThrow(Exception());
  }
}
