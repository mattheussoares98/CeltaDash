import '../../data/database/database.dart';
import 'package:hive/hive.dart';

import '../helpers/helpers.dart';

class HiveAdapter implements HiveStorage {
  final Box box;

  HiveAdapter({required this.box});

  @override
  Future<void> delete(DatabaseKeys key) async {
    await box.delete(key.name);
  }

  @override
  Future<dynamic> get(DatabaseKeys key) async {
    return await box.get(key.name);
  }

  @override
  Future<void> put(DatabaseKeys key, dynamic value) async {
    await box.delete(key.name);
    await box.put(key.name, value);
  }
}
