import '../../infra/helpers/helpers.dart';

abstract class HiveStorage {
  Future<dynamic> get(DatabaseKeys key);
  Future<void> delete(DatabaseKeys key);
  Future<void> put(DatabaseKeys key, dynamic value);
}
