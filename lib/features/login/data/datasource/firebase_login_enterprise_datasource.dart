// lib/features/login/data/datasource/firebase_login_enterprise_datasource.dart
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/login/data/datasource/i_firebase_login_enterprise_datasource.dart';
import 'package:celta_dash/utils/utils.dart';

class FirebaseLoginEnterpriseDatasource
    implements IFirebaseLoginEnterpriseDatasource {
  final FirebaseStorage firebaseStorage;

  const FirebaseLoginEnterpriseDatasource(this.firebaseStorage);

  @override
  Future<FirebaseEnterpriseModel> getEnterpriseConfig({
    required String enterpriseName,
  }) async {
    try {
      final cleanName = enterpriseName.trim().toLowerCase().removeWhiteSpaces();
      final snapshot = await firebaseStorage.get(
        path: 'enterprises/$cleanName',
      );
      final data = snapshot?.data();

      if (data == null) {
        throw DomainError.enterpriseNotFound;
      }

      final Map mutableData = Map.from(data);
      mutableData['firebaseId'] = snapshot.id;
      mutableData['enterpriseName'] = enterpriseName.trim();

      return FirebaseEnterpriseModel.fromJson(mutableData);
    } catch (e) {
      if (e is DomainError) rethrow;
      throw DomainError.enterpriseNotFound;
    }
  }
}
