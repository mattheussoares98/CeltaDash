import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseStorage {
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    String? fieldToSearch,
    String? valueToSearch,
  });

  Future<void> put({
    CollectionReference<Map<String, dynamic>>? collectionReference,
    DocumentReference<Map<String, dynamic>>? documentReference,
    List<Map<String, FieldValue>?> increment,
    List<Map<String, FieldValue>?> arrayUnion,
    bool? merge,
    required Map<String, dynamic>? data,
  });
}
