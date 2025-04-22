import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteFirebaseManager implements FirebaseManager {
  final FirebaseStorage firebaseStorage;

  RemoteFirebaseManager({required this.firebaseStorage});
  @override
  Future get({
    required String collection,
    String? doc,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    return await firebaseStorage.get(
      collection: collection,
      doc: doc,
      fieldToSearch: fieldToSearch,
      valueToSearch: valueToSearch,
    );
  }

  @override
  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required DocumentReference<Map<String, dynamic>> documentReference,
    required Map<String, dynamic>? data,
  }) async {
    await firebaseStorage.put(
      documentReference: documentReference,
      data: data,
      arrayUnion: arrayUnion,
      increment: increment,
      merge: merge,
    );
  }
}
