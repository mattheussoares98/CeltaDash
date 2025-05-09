import '../../../ui/helpers/helpers.dart';
import '../../../data/models/models.dart';
import '../../pages/pages.dart';

extension SaleMovementsExtensions on List<SaleMovementViewModel> {
  double sumLiquidValue({
    int? filterYear,
    int? filterMonth,
    int? filterDay,
    EnterpriseViewModel? enterprise,
  }) {
    return filteredSales(
      enterprise: enterprise,
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
    return filteredSales(
      enterprise: enterprise,
      filterYear: filterYear,
      filterMonth: filterMonth,
      filterDay: filterDay,
    ).fold<int>(
      0,
      (sum, e) => sum + (e.QuantitySales ?? 1),
    );
  }

  double ticketAverage(
    EnterpriseViewModel? enterprise, {
    int? filterYear,
    int? filterMonth,
    int? filterDay,
  }) {
    final filtered = filteredSales(
      enterprise: enterprise,
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

  double weekDayAverage(EnterpriseViewModel? enterprise) {
    final now = DateTime.now();
    final totalSales = filteredSales(
      enterprise: enterprise,
      filterYear: now.year,
      filterWeekday: now.weekday,
    ).fold<double>(
      0.0,
      (sum, e) => sum + (e.LiquidValue ?? 0),
    );

    final start = DateTime(now.year, 1, 1);
    final totalDays = now.difference(start).inDays + 1;
    final mondaysQuantity = totalDays ~/ 7;

    return totalSales / mondaysQuantity;
  }

  List<SaleMovementModel> filteredSales({
    EnterpriseViewModel? enterprise,
    int? filterYear,
    int? filterMonth,
    int? filterDay,
    int? filterWeekday,
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

          // Dart: segunda = 1, domingo = 7
          final matchesWeekday =
              filterWeekday == null || viewModel.Date?.weekday == filterWeekday;

          return matchesEnterprise &&
              matchesYear &&
              matchesMonth &&
              matchesDay &&
              matchesWeekday;
        })
        .map(SaleMovementModel.fromViewModel)
        .toList();
  }

  HoursComparisonViewModel hourAverage({
    required bool getBest,
    int? filterYear,
    int? filterMonth,
    int? filterDay,
    EnterpriseViewModel? enterprise,
  }) {
    final filtered = filteredSales(
      enterprise: enterprise,
      filterYear: filterYear,
      filterMonth: filterMonth,
      filterDay: filterDay,
    );

    // Agrupar soma e contagem por hora
    final Map<String, double> liquidValueByHour = {};
    final Map<String, int> countByHour = {};

    for (final sale in filtered) {
      final hour = sale.Hour?.toString() ?? 'unknown';
      final quantity = sale.LiquidValue ?? 0;

      liquidValueByHour[hour] = (liquidValueByHour[hour] ?? 0) + quantity;
      countByHour[hour] = (countByHour[hour] ?? 0) + 1;
    }

    if (liquidValueByHour.isEmpty || countByHour.isEmpty) {
      return HoursComparisonViewModel(value: 0, hour: "unknown");
    }

    // Calcular a média de cada hora
    final Map<String, double> averageByHour = {};
    for (final hour in liquidValueByHour.keys) {
      final total = liquidValueByHour[hour]!;
      final count = countByHour[hour]!;
      averageByHour[hour] = total / count;
    }

    // Encontrar a melhor ou pior hora com base na média
    final selectedHour = averageByHour.entries.fold(
      averageByHour.entries.first,
      (previous, current) {
        final isBetter = current.value > previous.value;
        return getBest
            ? (isBetter ? current : previous)
            : (isBetter ? previous : current);
      },
    );

    return HoursComparisonViewModel(
      hour: selectedHour.key,
      value: selectedHour.value,
    );
  }

  /// All distinct, non-null hour strings in your list.
  List<String> get uniqueHours =>
      map((e) => e.Hour).whereType<String>().toSet().toList();

  double totalForHourOnDate(String hour, DateTime date) => where((e) =>
          e.Hour == hour &&
          e.Date?.year == date.year &&
          e.Date?.month == date.month &&
          e.Date?.day == date.day)
      .fold(0.0, (sum, e) => sum + (e.LiquidValue?.toDouble() ?? 0));

  double differenceForHour(double day1, double day2) {
    if (day1 == 0 && day2 == 0) return 0.0;
    if (day1 == 0) return -100.0;
    return ((day1 - day2) / day1) * 100;
  }
}
