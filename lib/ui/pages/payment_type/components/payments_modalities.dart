import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentsModalities extends StatefulWidget {
  final List<SaleStatisticViewModel> saleStatistics;
  final bool filterByFinalizations;
  const PaymentsModalities({
    super.key,
    required this.saleStatistics,
    required this.filterByFinalizations,
  });

  @override
  State<PaymentsModalities> createState() => _PaymentsModalitiesState();
}

class _PaymentsModalitiesState extends State<PaymentsModalities> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableItem(
          titles: [
            PersonalizedTableCell(value: R.string.paymentsType),
            PersonalizedTableCell(value: R.string.total),
            PersonalizedTableCell(value: R.string.ticketAverage),
            PersonalizedTableCell(value: R.string.share),
          ],
          columnIndexToCompareAndDetachBetterAndWorstValue: 1,
          tableColumnWidth: {
            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15),
          },
          titleMinHeight: 40,
          indexToSort: 1,
          columnsIndexToSum: [1],
          rowValues: widget.saleStatistics
              .fold<Map<String, List<SaleStatisticViewModel>>>({}, (acc, sale) {
                final key = widget.filterByFinalizations
                    ? sale.PaymentFinalization ?? 'Undefined'
                    : sale.PaymentModality ?? 'Undefined';
                acc.putIfAbsent(key, () => []).add(sale);
                return acc;
              })
              .entries
              .map((entry) {
                final modality = entry.key;
                final sales = entry.value;
                final totalValue = sales.fold<double>(
                    0, (sum, s) => sum + (s.LiquidValue?.toDouble() ?? 1));
                final totalQuantity = sales.fold<int>(
                    0, (sum, s) => sum + (s.QuantitySales?.toInt() ?? 1));
                final overallValue =
                    widget.saleStatistics.toList().sumLiquidValue();
        
                return [
                  PersonalizedTableCell(
                    value: modality,
                    subtile: "$totalQuantity ${R.string.sales.toLowerCase()}",
                  ),
                  PersonalizedTableCell(value: totalValue, isMoney: true),
                  PersonalizedTableCell(
                    value: totalQuantity > 0 ? totalValue / totalQuantity : 0,
                    isMoney: true,
                  ),
                  PersonalizedTableCell(
                    value: (totalValue / overallValue) * 100,
                    isPercentage: true,
                  ),
                ];
              })
              .toList(),
        ),
      ],
    );
  }
}
