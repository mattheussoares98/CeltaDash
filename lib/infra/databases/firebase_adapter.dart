import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/database/database.dart';
import '../../domain/helpers/helpers.dart';

class FirebaseAdapter implements FirebaseStorage {
  final instance = FirebaseFirestore.instance;

  @override
  Future<dynamic> get({
    required String collection,
    String? doc,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    if (fieldToSearch == null || valueToSearch == null) {
      return doc == null
          ? await instance.collection(collection).get()
          : await instance.collection(collection).doc(doc).get();
    } else {
      return await instance
          .collection(collection)
          .where(fieldToSearch, isEqualTo: valueToSearch)
          .get();
    }
  }

  @override
  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required DocumentReference<Map<String, dynamic>> documentReference,
    required Map<String, dynamic>? data,
  }) async {
    final json = data;
    if (increment != null) {
      json!.addAll(increment.first!);
    }
    if (arrayUnion != null) {
      json!.addAll(arrayUnion.first!);
    }

    if ((increment == null && arrayUnion == null && data == null) ||
        json == null) {
      throw DomainError.unexpected;
    }

    await documentReference.set(json, SetOptions(merge: merge == true));
  }
}
