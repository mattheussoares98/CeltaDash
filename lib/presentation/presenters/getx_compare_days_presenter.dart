import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCompareDaysPresenter extends GetxController
    with UIErrorManager, LoadingManager
    implements CompareDaysPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxCompareDaysPresenter({
    required this.loadSaleMovements,
  });

  final _firstDayMovements = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get firstDayMovements =>
      _firstDayMovements.value;

  final _secondDayMovements = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get secondDayMovements =>
      _secondDayMovements.value;

  @override
  Future<void> getSales({
    required DateTime firstDay,
    required DateTime secondDay,
  }) async {
    _selectedFirstDay = firstDay;
    _selectedSecondDay = secondDay;

    isLoading = true;
    mainError = null;

    try {
      final firstDayMovements = await loadSaleMovements.get(
        startDate: firstDay,
        endDate: firstDay,
      );

      _firstDayMovements.value = firstDayMovements
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      final secondDayMovements = await loadSaleMovements.get(
        startDate: secondDay,
        endDate: secondDay,
      );

      _secondDayMovements.value = secondDayMovements
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  DateTime? _selectedFirstDay;
  @override
  DateTime? get selectedFirstDay => _selectedFirstDay;

  DateTime? _selectedSecondDay;
  @override
  DateTime? get selectedSecondDay => _selectedSecondDay;
}
