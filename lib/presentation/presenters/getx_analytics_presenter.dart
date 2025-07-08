import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxAnalyticsPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements AnalyticsPresenter {
  final FirebaseManager firebaseManager;

  GetxAnalyticsPresenter({
    required this.firebaseManager,
  });

  @override
  Future<void> loadAnalytics() async {
    try {
      isLoading = true;
      mainError = null;

      final docId = DateFormat('yyyy-MM').format(DateTime.now());

      final data =
          await firebaseManager.get(path: "analytics/monthly_analytics/$docId");

      List<MonthlyAnalyticsModel> analytics = [];
      if (data != null && data.docs.isNotEmpty) {
        analytics = (data.docs as List)
            .map((e) =>
                MonthlyAnalyticsModel.fromJson(e.data(), enterpriseId: e.id))
            .toList();
      }
      // I didnt want add tests for this
    } catch (e) {
      debugPrint(e.toString());
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
