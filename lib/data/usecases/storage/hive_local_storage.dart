import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';
import '../../mixins/mixins.dart';

class HiveLocalStorage with ErrorHandling implements LocalStorage {
  final HiveStorage hiveAdapter;
  //TODO move to the new architecture
  HiveLocalStorage(this.hiveAdapter);

  @override
  Future<dynamic> get(DatabaseKeys key) async {
    try {
      return await hiveAdapter.get(key) as dynamic;
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> put(DatabaseKeys key, dynamic value) async {
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
