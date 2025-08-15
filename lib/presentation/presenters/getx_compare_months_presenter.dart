import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxCompareMonthsPresenter extends GetxController
    with ErrorHandling, UIErrorManager, LoadingManager
    implements CompareMonthsPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxCompareMonthsPresenter({
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();
  final homePresenter = Get.find<HomePresenter>();

  late DateTime _now;
  @override
  void onInit() {
    super.onInit();
    _now = DateTime.now();
  }

  @override
  void changeSelectedFirstMonth(int? month) {
    // TODO: implement changeSelectedFirstMonth
  }

  @override
  void changeSelectedFirstYear(int? year) {
    // TODO: implement changeSelectedFirstYear
  }

  @override
  void changeSelectedSecondMonth(int? month) {
    // TODO: implement changeSelectedSecondMonth
  }

  @override
  void changeSelectedSecondYear(int? year) {
    // TODO: implement changeSelectedSecondYear
  }

  @override
  // TODO: implement firstMonthSales
  List<SaleStatisticViewModel> get firstMonthSales =>
      throw UnimplementedError();

  @override
  Future<void> getSales() {
    // TODO: implement getSales
    throw UnimplementedError();
  }

  @override
  // TODO: implement secondMonthSales
  List<SaleStatisticViewModel> get secondMonthSales =>
      throw UnimplementedError();

  @override
  // TODO: implement selectedFirstMonth
  int get selectedFirstMonth => throw UnimplementedError();

  @override
  // TODO: implement selectedFirstYear
  int get selectedFirstYear => throw UnimplementedError();

  @override
  // TODO: implement selectedSecondMonth
  int get selectedSecondMonth => throw UnimplementedError();

  @override
  // TODO: implement selectedSecondYear
  int get selectedSecondYear => throw UnimplementedError();
}
