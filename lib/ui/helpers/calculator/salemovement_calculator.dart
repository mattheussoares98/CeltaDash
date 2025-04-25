import '../../../data/models/models.dart';
import '../../pages/pages.dart';

extension SaleMovementsExtensions on List<SaleMovementViewModel> {
  double totalByDay({DateTime? filterDate}) {
    final day = (filterDate ?? DateTime.now()).day;

    return _salesEntitys()
        .where((e) => filterDate == null ? true : e.Date?.day == day)
        .fold(
          0.0,
          (previousValue, element) =>
              previousValue + (element.LiquidValue ?? 0),
        );
  }

  List<SaleMovementModel> _salesEntitys() =>
      this.map((e) => SaleMovementModel.fromViewModel(e)).toList();
}
