import 'package:celta_dash/core/infrastructure/storage/storage.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';

class HiveLocalStorage implements LocalStorage {
  final HiveStorage hiveAdapter;
  //TODO move to the new architecture
  HiveLocalStorage(this.hiveAdapter);

  @override
  Future<dynamic> get(DatabaseKeys key) async {
    return await hiveAdapter.get(key) as dynamic;
  }

  @override
  Future<void> put(DatabaseKeys key, dynamic value) async {
    await hiveAdapter.put(key, value);
  }

  @override
  Future<void> delete(DatabaseKeys key) async {
    await hiveAdapter.delete(key);
  }
}
