abstract class HiveStorage {
  Future<dynamic> get(String key);
  Future<void> delete(String key);
  Future<void> put(String key, dynamic value);
}
