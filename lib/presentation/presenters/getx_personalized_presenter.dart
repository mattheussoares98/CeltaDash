import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxPersonalizedPresenter extends GetxController
    with ErrorHandling, SaleStatisticsManager, UIErrorManager, LoadingManager
    implements PersonalizedPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxPersonalizedPresenter({
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();
}
