import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager, SaleMovementManager
    implements ProductsPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxProductsPresenter({required this.loadSaleMovements});

  @override
  Future<void> loadProducts(
    HomePresenter homePresenter, {
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (forceRefresh != true &&
          _lastDateLoadedData?.year == homePresenter.selectedDate.year &&
          _lastDateLoadedData?.month == homePresenter.selectedDate.month &&
          _lastDateLoadedData?.day == homePresenter.selectedDate.day) {
        return;
      }
      final date = homePresenter.selectedDate;
      final response = await loadSaleMovements.get(
        startDate: DateTime(date.year, date.month, date.day, 0, 0, 0),
        endDate: DateTime(date.year, date.month, date.day, 23, 59, 59),
        //TODO fix this start and end after Cardoso fix problems to load data. Is returing a lot of data, this is why I am filtering only one day
        // startDate: DateTime(
        //   homePresenter.selectedDate.year,
        //   homePresenter.selectedDate.month,
        //   1,
        // ),
        // endDate: DateTime(
        //   homePresenter.selectedDate.year,
        //   homePresenter.selectedDate.month + 1,
        // ).subtract(Duration(days: 1)),
        groupByDay: true,
        groupByProduct: true,
        groupByEnterprise: true,
        enterpriseIds: homePresenter.selectedEnterprise == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
      );

      saleMovements = (response as List)
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      _lastDateLoadedData = homePresenter.selectedDate;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  DateTime? _lastDateLoadedData;
  @override
  DateTime? get lastDateLoadedData => _lastDateLoadedData;
}
