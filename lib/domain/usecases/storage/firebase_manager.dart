import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseManager {
  Future<dynamic> get({
    required String collection,
    String? doc,
    String? fieldToSearch,
    String? valueToSearch,
  });

  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required DocumentReference<Map<String, dynamic>> documentReference,
    required Map<String, dynamic> data,
  });
}
