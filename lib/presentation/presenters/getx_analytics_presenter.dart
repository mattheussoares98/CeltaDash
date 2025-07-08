import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxAnalyticsPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements AppAnalyticsPresenter {
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
          await firebaseManager.get(path: "analytics/$docId/informations");

      if (data != null && data.docs.isNotEmpty) {
        _analytics.value = (data.docs as List)
            .map((e) => MonthlyAnalyticsViewModel.fromEntity(
                MonthlyAnalyticsModel.fromJson(e.data(), enterpriseId: e.id)
                    .toEntity()))
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

  final _analytics = Rx<List<MonthlyAnalyticsViewModel>?>(null);
  @override
  List<MonthlyAnalyticsViewModel>? get analytics => _analytics.value;
}
