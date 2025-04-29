import '../../../data/models/models.dart';
import '../../pages/pages.dart';

extension SaleMovementsExtensions on List<SaleMovementViewModel> {
  double sumLiquidValue({
    DateTime? filterDate,
    EnterpriseViewModel? enterprise,
  }) {
    return _filteredSales(filterDate, enterprise).fold<double>(
      0.0,
      (sum, e) => sum + (e.LiquidValue ?? 0),
    );
  }

  int quantitySales({
    DateTime? filterDate,
    EnterpriseViewModel? enterprise,
  }) {
    return _filteredSales(filterDate, enterprise).fold<int>(
      0,
      (sum, e) => sum + (e.QuantitySales ?? 0),
    );
  }

  double ticketAverage({
    DateTime? filterDate,
    EnterpriseViewModel? enterprise,
  }) {
    final filtered = _filteredSales(filterDate, enterprise);
    final totalQuantity =
        filtered.fold<int>(0, (p, e) => p + (e.QuantitySales ?? 0));
    if (totalQuantity == 0) return 0;

    final totalValue =
        filtered.fold<double>(0.0, (p, e) => p + (e.LiquidValue ?? 0));
    return totalValue / totalQuantity;
  }

  List<SaleMovementModel> _filteredSales(
    DateTime? filterDate,
    EnterpriseViewModel? enterprise,
  ) {
    return this
        .where((viewModel) {
          final matchesEnterprise = enterprise == null ||
              viewModel.EnterprisePersonalizedCode ==
                  enterprise.personalizedCode;

          final matchesDate = filterDate == null ||
              viewModel.Date?.year == filterDate.year &&
                  viewModel.Date?.month == filterDate.month &&
                  viewModel.Date?.day == filterDate.day;

          return matchesEnterprise && matchesDate;
        })
        .map(SaleMovementModel.fromViewModel)
        .toList();
  }
}
