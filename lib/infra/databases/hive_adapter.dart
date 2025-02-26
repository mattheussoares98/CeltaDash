import '../../data/database/database.dart';
import 'package:hive/hive.dart';

class HiveAdapter implements HiveStorage {
  final Box box;

  HiveAdapter({required this.box});

  @override
  Future<void> delete(String key) async {
    await box.delete(key);
  }

  @override
  Future<dynamic> get(String key) async {
    return await box.get(key);
  }

  @override
  Future<void> put(String key, value) async {
    await box.delete(key);
    await box.put(key, value);
  }
}
