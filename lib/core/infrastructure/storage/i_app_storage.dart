abstract class IAppStorage {
  Future<dynamic> get(String key);

  Future<void> put(String key, dynamic value);

  Future<void> delete(String key);
}
