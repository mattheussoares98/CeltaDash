import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';

class LegacyAppStorage implements IAppStorage {
  const LegacyAppStorage(this._storage);

  final LocalStorage _storage;

  @override
  Future<dynamic> get(String key) =>
      _storage.get(DatabaseKeys.values.byName(key));

  @override
  Future<void> put(String key, dynamic value) =>
      _storage.put(DatabaseKeys.values.byName(key), value);
}
