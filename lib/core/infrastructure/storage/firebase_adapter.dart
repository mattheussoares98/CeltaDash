import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdapter implements FirebaseStorage {
  FirebaseFirestore get instance => FirebaseFirestore.instance;

  @override
  Future<dynamic> get({
    required String path,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    final pathSegments = path.split('/');

    // If path has an odd number of segments, it's a collection query
    if (pathSegments.length % 2 != 0) {
      final collectionRef = instance.collection(path);
      try {
        if (fieldToSearch != null && valueToSearch != null) {
          return await collectionRef
              .where(fieldToSearch, isEqualTo: valueToSearch)
              .get()
              .timeout(const Duration(seconds: 30));
        } else {
          return await collectionRef.get().timeout(const Duration(seconds: 30));
        }
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable') {
          try {
            if (fieldToSearch != null && valueToSearch != null) {
              return await collectionRef
                  .where(fieldToSearch, isEqualTo: valueToSearch)
                  .get(const GetOptions(source: Source.cache));
            } else {
              return await collectionRef.get(
                const GetOptions(source: Source.cache),
              );
            }
          } catch (_) {
            return null;
          }
        }
        rethrow;
      }
    }
    // If path has an even number of segments, it's a document query
    else {
      try {
        return await instance
            .doc(path)
            .get()
            .timeout(const Duration(seconds: 30));
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable') {
          try {
            return await instance
                .doc(path)
                .get(const GetOptions(source: Source.cache));
          } catch (_) {
            return null;
          }
        }
        rethrow;
      }
    }
  }

  @override
  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required String path,
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
      throw 'Ocorreu um erro não esperado durante a operação'.hardcoded;
    }

    final pathSegments = path.split('/');
    if (pathSegments.length % 2 != 0) {
      throw ArgumentError(
        'Invalid document path: $path. Path must have an even number of segments.',
      );
    }

    // Create the DocumentReference from the path
    final DocumentReference<Map<String, dynamic>> documentReference = instance
        .doc(path);

    await documentReference
        .set(json, SetOptions(merge: merge == true))
        .timeout(const Duration(seconds: 30));
  }
}
