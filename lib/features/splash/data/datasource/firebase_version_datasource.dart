import 'package:celta_dash/data/database/database.dart';
import 'package:celta_dash/features/splash/data/datasource/i_version_datasource.dart';

class FirebaseVersionDatasource implements IVersionDatasource {
  final FirebaseStorage firebaseStorage;

  const FirebaseVersionDatasource(this.firebaseStorage);

  @override
  Future<String?> getRequiredVersion() async {
    try {
      final snapshot = await firebaseStorage.get(
        path: 'requiredVersion/version',
      );
      final data = snapshot?.data();
      if (data != null && data is Map) {
        return data['required'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
