import '../../../infra/helpers/helpers.dart';

abstract class LocalStorage {
  Future<T?> get<T>(DatabaseKeys key);
  Future<void> put<T>(DatabaseKeys key, T value);
  Future<void> delete(DatabaseKeys key);
}
