import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteFirebaseManager implements FirebaseManager {
  final FirebaseStorage firebaseStorage;

  RemoteFirebaseManager({required this.firebaseStorage});
  @override
  Future get({
    required String path,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    return await firebaseStorage.get(
      path: path,
      fieldToSearch: fieldToSearch,
      valueToSearch: valueToSearch,
    );
  }

  @override
  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await firebaseStorage.put(
      path: path,
      data: data,
      arrayUnion: arrayUnion,
      increment: increment,
      merge: merge,
    );
  }
}
