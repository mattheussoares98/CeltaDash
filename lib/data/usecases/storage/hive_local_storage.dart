import 'package:celta_plus/infra/helpers/database_keys.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/databases/databases.dart';

class HiveLocalStorage implements LocalStorage {
  final HiveAdapter hiveAdapter;

  HiveLocalStorage(this.hiveAdapter);

  @override
  Future<T?> get<T>(DatabaseKeys key) async {
    try {
      return await hiveAdapter.get(key) as T;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> put<T>(DatabaseKeys key, T value) async {
    try {
      await hiveAdapter.put(key, value);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> delete(DatabaseKeys key) async {
    try {
      await hiveAdapter.delete(key);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
