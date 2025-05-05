import '../../../data/models/models.dart';
import '../../pages/pages.dart';

extension SaleMovementsExtensions on List<SaleMovementViewModel> {
  double sumLiquidValue({
    int? filterYear,
    int? filterMonth,
    int? filterDay,
    EnterpriseViewModel? enterprise,
  }) {
    return _filteredSales(
      enterprise,
      filterYear: filterYear,
      filterMonth: filterMonth,
      filterDay: filterDay,
    ).fold<double>(
      0.0,
      (sum, e) => sum + (e.LiquidValue ?? 0),
    );
  }

  int quantitySales({
    int? filterYear,
    int? filterMonth,
    int? filterDay,
    EnterpriseViewModel? enterprise,
  }) {
    return _filteredSales(
      enterprise,
      filterYear: filterYear,
      filterMonth: filterMonth,
      filterDay: filterDay,
    ).fold<int>(
      0,
      (sum, e) => sum + (e.QuantitySales ?? 0),
    );
  }

  double ticketAverage(
    EnterpriseViewModel? enterprise, {
    int? filterYear,
    int? filterMonth,
    int? filterDay,
  }) {
    final filtered = _filteredSales(
      enterprise,
      filterYear: filterYear,
      filterMonth: filterMonth,
      filterDay: filterDay,
    );
    final totalQuantity =
        filtered.fold<int>(0, (p, e) => p + (e.QuantitySales ?? 0));
    if (totalQuantity == 0) return 0;

    final totalValue =
        filtered.fold<double>(0.0, (p, e) => p + (e.LiquidValue ?? 0));
    return totalValue / totalQuantity;
  }

  List<SaleMovementModel> _filteredSales(
    EnterpriseViewModel? enterprise, {
    required int? filterYear,
    required int? filterMonth,
    required int? filterDay,
  }) {
    return this
        .where((viewModel) {
          final matchesEnterprise = enterprise == null ||
              viewModel.EnterprisePersonalizedCode ==
                  enterprise.personalizedCode;

          final matchesYear =
              filterYear == null || viewModel.Date?.year == filterYear;
          final matchesMonth =
              filterMonth == null || viewModel.Date?.month == filterMonth;
          final matchesDay =
              filterDay == null || viewModel.Date?.day == filterDay;

          return matchesEnterprise && matchesYear && matchesMonth && matchesDay;
        })
        .map(SaleMovementModel.fromViewModel)
        .toList();
  }
}
