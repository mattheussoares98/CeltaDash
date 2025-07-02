import '../../../infra/helpers/helpers.dart';

abstract class LocalStorage {
  Future<dynamic> get(DatabaseKeys key);
  Future<void> put(DatabaseKeys key, dynamic value);
  Future<void> delete(DatabaseKeys key);
}
