import 'package:celta_dash/data/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FakeHomeGoalFirebaseStorage implements FirebaseStorage {
  dynamic getResult;
  Object? getError;
  Object? putError;
  String? getPath;
  String? putPath;
  Map<String, dynamic>? putData;
  bool? putMerge;

  @override
  Future<dynamic> get({
    required String path,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    if (getError case final error?) throw error;
    getPath = path;
    return getResult;
  }

  @override
  Future<void> put({
    List<Map<String, FieldValue>?>? increment,
    List<Map<String, FieldValue>?>? arrayUnion,
    bool? merge,
    required String path,
    required Map<String, dynamic>? data,
  }) async {
    if (putError case final error?) throw error;
    putPath = path;
    putData = data;
    putMerge = merge;
  }
}
