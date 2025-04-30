import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentsModalities extends StatefulWidget {
  final List<SaleMovementViewModel> saleMovements;
  final bool filterByModality;
  const PaymentsModalities({
    super.key,
    required this.saleMovements,
    required this.filterByModality,
  });

  @override
  State<PaymentsModalities> createState() => _PaymentsModalitiesState();
}

class _PaymentsModalitiesState extends State<PaymentsModalities> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.filterByModality
              ? R.string.modalities
              : R.string.finalizations,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        TableItem(
          titles: [
            PersonalizedTableCell(value: R.string.paymentsType),
            PersonalizedTableCell(value: R.string.total),
            PersonalizedTableCell(value: R.string.ticketAverage),
            PersonalizedTableCell(value: R.string.share),
          ],
          columnIndexToCompareAndDetachBetterAndWorstValue: 3,
          tableColumnWidth: {
            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.17),
          },
          titleMinHeight: 40,
          indexToSort: 3,
          columnsIndexToSum: [1],
          rowValues: widget.saleMovements
              .fold<Map<String, List<SaleMovementViewModel>>>({},
                  (acc, sale) {
                final key = widget.filterByModality
                    ? (sale.PaymentModality ?? 'Undefined')
                    : sale.PaymentFinalization ?? 'Undefined';
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
                    widget.saleMovements.toList().sumLiquidValue();
    
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
