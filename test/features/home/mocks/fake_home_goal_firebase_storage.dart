import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FakeHomeGoalFirebaseStorage implements FirebaseStorage {
  dynamic getResult;
  final Map<String, dynamic> resultsByPath = {};
  Object? getError;
  Object? putError;
  String? getPath;
  final List<String> getPaths = [];
  String? putPath;
  final List<String> putPaths = [];
  Map<String, dynamic>? putData;
  final List<Map<String, dynamic>?> putDataList = [];
  bool? putMerge;

  @override
  Future<dynamic> get({
    required String path,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    if (getError case final error?) throw error;
    getPath = path;
    getPaths.add(path);
    if (resultsByPath.containsKey(path)) return resultsByPath[path];
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
    putPaths.add(path);
    putData = data;
    putDataList.add(data);
    putMerge = merge;
  }
}
