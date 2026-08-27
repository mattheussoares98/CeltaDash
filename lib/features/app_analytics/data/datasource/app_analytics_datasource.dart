// lib/features/app_analytics/data/datasource/app_analytics_datasource.dart
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/app_analytics/data/datasource/datasource.dart';
import 'package:celta_dash/features/app_analytics/data/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppAnalyticsDatasource implements IAppAnalyticsDatasource {
  final FirebaseStorage firebaseStorage;
  final IAppStorage? localStorage;

  AppAnalyticsDatasource({required this.firebaseStorage, this.localStorage});

  @override
  Future<List<AppAnalyticsModel>> getAnalytics(DateTime period) async {
    final month = period.formatDate(.yyyyMM);
    final snapshot = await firebaseStorage.get(
      path: 'analytics/$month/informations',
    );
    final documents = _readDocuments(snapshot);
    if (documents is! Iterable) return const [];

    return documents
        .map<AppAnalyticsModel?>(_parseAnalytics)
        .whereType<AppAnalyticsModel>()
        .toList(growable: false);
  }

  AppAnalyticsModel? _parseAnalytics(dynamic document) {
    final data = document.data();
    if (data is! Map) return null;
    return AppAnalyticsModel.fromJson(
      data,
      enterpriseId: document.id as String,
    );
  }

  @override
  Future<AppAnalyticsModel> loadLocalMonthlyAnalytics({
    required String enterpriseId,
  }) async {
    if (localStorage == null) {
      return AppAnalyticsModel(
        searchCounts: const [],
        users: const [],
        enterprise: enterpriseId,
      );
    }
    final localData = await localStorage!.get(DatabaseKeys.monthlyAnalytics.name);
    if (localData != null && localData is Map) {
      return AppAnalyticsModel.fromJson(localData, enterpriseId: enterpriseId);
    }
    return AppAnalyticsModel(
      searchCounts: const [],
      users: const [],
      enterprise: enterpriseId,
    );
  }

  @override
  Future<void> saveLocalMonthlyAnalytics(AppAnalyticsModel model) async {
    await localStorage?.put(DatabaseKeys.monthlyAnalytics.name, model.toJson());
  }

  @override
  Future<void> clearLocalMonthlyAnalytics() async {
    await localStorage?.delete(DatabaseKeys.monthlyAnalytics.name);
  }

  @override
  Future<void> syncAnalytics({
    required String docId,
    required String enterpriseName,
    required AppAnalyticsModel model,
  }) async {
    final cleanEnterpriseName = enterpriseName
        .trim()
        .toLowerCase()
        .removeWhiteSpaces();

    await firebaseStorage.put(
      path: 'analytics/$docId/informations/$cleanEnterpriseName',
      data: {
        for (final count in model.searchCounts)
          '${count.reportType.name}-${count.periodType.name}':
              FieldValue.increment(count.count),
        'users': FieldValue.arrayUnion([
          for (final user in model.users)
            {'userName': user.userName, 'platform': user.platform},
        ]),
      },
      merge: true,
    );
  }

  @override
  Future<DateTime?> getLastSyncDate() async {
    final rawDate = await localStorage?.get(
      DatabaseKeys.lastAnalyticsSyncDate.name,
    );
    if (rawDate is String) {
      return DateTime.tryParse(rawDate);
    }
    return null;
  }

  @override
  Future<void> saveLastSyncDate(DateTime date) async {
    await localStorage?.put(
      DatabaseKeys.lastAnalyticsSyncDate.name,
      date.toIso8601String(),
    );
  }

  dynamic _readDocuments(dynamic snapshot) {
    if (snapshot == null) return null;
    try {
      return (snapshot as dynamic).docs;
    } catch (_) {
      return null;
    }
  }
}
