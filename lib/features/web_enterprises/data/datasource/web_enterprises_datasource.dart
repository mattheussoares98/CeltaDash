import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/web_enterprises/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_enterprises/data/models/models.dart';
import 'package:intl/intl.dart';

class WebEnterprisesDatasource implements IWebEnterprisesDatasource {
  final FirebaseStorage firebaseStorage;

  const WebEnterprisesDatasource(this.firebaseStorage);

  @override
  Future<List<FirebaseEnterpriseModel>> getEnterprises() async {
    final snapshot = await firebaseStorage.get(path: 'enterprises');
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<FirebaseEnterpriseModel?>(_parseEnterprise)
        .whereType<FirebaseEnterpriseModel>()
        .toList(growable: false);
  }

  @override
  Future<List<WebAnalyticsModel>> getAnalytics(DateTime period) async {
    final month = DateFormat('yyyy-MM').format(period);
    final snapshot = await firebaseStorage.get(
      path: 'analytics/$month/informations',
    );
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<WebAnalyticsModel?>(_parseAnalytics)
        .whereType<WebAnalyticsModel>()
        .toList(growable: false);
  }

  FirebaseEnterpriseModel? _parseEnterprise(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return FirebaseEnterpriseModel.fromJson(
      data,
      documentId: document.id as String?,
    );
  }

  WebAnalyticsModel? _parseAnalytics(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return WebAnalyticsModel.fromJson(
      data,
      enterpriseId: document.id as String,
    );
  }

  dynamic _readDocuments(dynamic snapshot) {
    try {
      return snapshot?.docs;
    } catch (_) {
      return null;
    }
  }
}
