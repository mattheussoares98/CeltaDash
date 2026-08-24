import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/data/database/database.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/web_enterprises/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_enterprises/data/models/models.dart';
import 'package:intl/intl.dart';

class WebEnterprisesDatasource implements IWebEnterprisesDatasource {
  final FirebaseStorage firebaseStorage;

  const WebEnterprisesDatasource(this.firebaseStorage);

  @override
  Future<List<FirebaseEnterpriseEntity>> getEnterprises() async {
    final snapshot = await firebaseStorage.get(path: 'enterprises');
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<FirebaseEnterpriseEntity?>(_parseEnterprise)
        .whereType<FirebaseEnterpriseEntity>()
        .toList(growable: false);
  }

  @override
  Future<List<MonthlyAnalyticsEntity>> getAnalytics(DateTime period) async {
    final month = DateFormat('yyyy-MM').format(period);
    final snapshot = await firebaseStorage.get(
      path: 'analytics/$month/informations',
    );
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<MonthlyAnalyticsEntity?>(_parseAnalytics)
        .whereType<MonthlyAnalyticsEntity>()
        .toList(growable: false);
  }

  FirebaseEnterpriseEntity? _parseEnterprise(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return FirebaseEnterpriseModel.fromJson(
      data,
      documentId: document.id as String?,
    ).toEntity();
  }

  MonthlyAnalyticsEntity? _parseAnalytics(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return WebAnalyticsModel.fromJson(
      data,
      enterpriseId: document.id as String,
    ).toEntity();
  }

  dynamic _readDocuments(dynamic snapshot) {
    try {
      return snapshot?.docs;
    } catch (_) {
      return null;
    }
  }
}
