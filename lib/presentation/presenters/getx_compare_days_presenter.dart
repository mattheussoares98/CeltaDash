import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
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
  }) async {}

  DateTime? _selectedFirstDay;
  @override
  DateTime? get selectedFirstDay => _selectedFirstDay;

  DateTime? _selectedSecondDay;
  @override
  DateTime? get selectedSecondDay => _selectedSecondDay;
}
