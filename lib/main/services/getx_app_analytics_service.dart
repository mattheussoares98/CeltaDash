import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../ui/services/services.dart';

class GetxAppAnalyticsService implements AppAnalyticsService {
  final FirebaseManager firebaseManager;
  final LocalStorage localStorage;

  GetxAppAnalyticsService({
    required this.firebaseManager,
    required this.localStorage,
  });

  @override
  Future<void> addNewMonthlyAnalytic({
    required ReportType reportType,
    required ReportPeriod reportPeriod,
    required String userName,
    required String platform,
  }) async {
    try {
      // 1. Load local monthly data and the update counter
      MonthlyAnalyticsEntity monthlyData = await _loadLocalMonthlyData();

      // 2. Update the data in memory with the new event information
      monthlyData = _updateMonthlyData(
        data: monthlyData,
        reportType: reportType,
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );
      int count = monthlyData.searchCounts.fold(0, (p, e) => p + e.count);

      // 3. Save the updated data and counter back to local storage
      await _saveLocalMonthlyData(monthlyData);

      // 4. If the update count reaches the threshold, sync with Firebase
      if (count >= 5) {
        final monthlyModel = MonthlyAnalyticsModel(
          searchCounts: monthlyData.searchCounts,
          users: monthlyData.users,
        );

        final docId = DateFormat('yyyy-MM').format(DateTime.now());
        final docRef = FirebaseFirestore.instance
            .collection('monthly_analytics')
            .doc(docId);

        // Send the data to Firebase, merging with existing data
        await firebaseManager.put(
          documentReference: docRef,
          data: monthlyModel.toJson(),
          merge: true,
        );

        debugPrint(
            'Analytics batch successfully synced and update counter reset.');
      }
    } catch (e) {
      // If anything fails, the local data is preserved for the next attempt.
      debugPrint('Error in addNewEvent: $e');
    }
  }

  /// Helper to load and parse the monthly analytics data from local storage.
  Future<MonthlyAnalyticsEntity> _loadLocalMonthlyData() async {
    final localData = await localStorage.get(DatabaseKeys.monthlyAnalytics);
    if (localData != null && localData is Map<String, dynamic>) {
      return MonthlyAnalyticsModel.fromJson(localData).toEntity();
    }
    // If no data exists, return an empty entity.
    return const MonthlyAnalyticsEntity(searchCounts: [], users: []);
  }

  /// Helper to save the monthly analytics data to local storage.
  Future<void> _saveLocalMonthlyData(MonthlyAnalyticsEntity data) async {
    final model = MonthlyAnalyticsModel(
        searchCounts: data.searchCounts, users: data.users);
    await localStorage.put(DatabaseKeys.monthlyAnalytics, model.toJson());
  }

  MonthlyAnalyticsEntity _updateMonthlyData({
    required MonthlyAnalyticsEntity data,
    required ReportType reportType,
    required ReportPeriod reportPeriod,
    required String userName,
    required String platform,
  }) {
    // --- Update Search Counts ---
    final searchCounts = List<SearchCountEntity>.from(data.searchCounts);
    final searchIndex = searchCounts.indexWhere(
        (sc) => sc.reportType == reportType && sc.reportPeriod == reportPeriod);

    if (searchIndex != -1) {
      final existing = searchCounts[searchIndex];
      searchCounts[searchIndex] = SearchCountEntity(
        reportType: existing.reportType,
        reportPeriod: existing.reportPeriod,
        count: existing.count + 1,
      );
    } else {
      searchCounts.add(SearchCountEntity(
        reportType: reportType,
        reportPeriod: reportPeriod,
        count: 1,
      ));
    }

    // --- Update Users ---
    final users = List<ActiveUserEntity>.from(data.users);
    final userIndex = users.indexWhere((u) => u.userName == userName);

    if (userIndex != -1) {
      users[userIndex] = ActiveUserEntity(
        userName: userName,
        platform: platform,
        lastActive: DateTime.now(),
      );
    } else {
      users.add(ActiveUserEntity(
        userName: userName,
        platform: platform,
        lastActive: DateTime.now(),
      ));
    }

    return MonthlyAnalyticsEntity(searchCounts: searchCounts, users: users);
  }
}
