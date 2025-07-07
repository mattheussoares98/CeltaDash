import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseManager {
  Future<dynamic> get({
    required String path,
    String? fieldToSearch,
    String? valueToSearch,
  });

  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required String path,
    required Map<String, dynamic> data,
  });
}
