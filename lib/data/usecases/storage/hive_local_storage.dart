import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';
import '../../mixins/mixins.dart';

class HiveLocalStorage with ErrorHandling implements LocalStorage {
  final HiveStorage hiveAdapter;

  HiveLocalStorage(this.hiveAdapter);

  @override
  Future<T?> get<T>(DatabaseKeys key) async {
    try {
      return await hiveAdapter.get(key) as T;
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> put<T>(DatabaseKeys key, T value) async {
    //TODO change to String
    try {
      await hiveAdapter.put(key, value);
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> delete(DatabaseKeys key) async {
    try {
      await hiveAdapter.delete(key);
    } catch (e) {
      treatError(e);
    }
  }
}
