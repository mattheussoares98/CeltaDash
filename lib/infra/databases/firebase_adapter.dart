import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdapter implements FirebaseStorage {
  FirebaseFirestore get instance => FirebaseFirestore.instance;

  @override
  Future<dynamic> get({
    required String path,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    try {
      final pathSegments = path.split('/');

      // If path has an odd number of segments, it's a collection query
      if (pathSegments.length % 2 != 0) {
        final collectionRef = instance.collection(path);
        if (fieldToSearch != null && valueToSearch != null) {
          return await collectionRef
              .where(fieldToSearch, isEqualTo: valueToSearch)
              .get()
              .timeout(const Duration(seconds: 30));
        } else {
          return await collectionRef.get().timeout(const Duration(seconds: 30));
        }
      }
      // If path has an even number of segments, it's a document query
      else {
        return await instance
            .doc(path)
            .get()
            .timeout(const Duration(seconds: 30));
      }
    } on FirebaseException {
      throw DomainError.unexpected;
    } catch (e) {
      throw DomainError.unexpected;
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
    try {
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
    } on FirebaseException {
      throw DomainError.unexpected;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
