import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
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
    final paymentTypePresenter = Get.find<PaymentTypePresenter>();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      children: [
        ScrollableTableItem(
          getSalesStatisticsParams:
              paymentTypePresenter.selectedPeriod == PeriodType.daily
              ? paymentTypePresenter.lastGetDailyParams
              : paymentTypePresenter.lastGetMonthlyParams,
          titleMinHeight: isPortrait ? 43 : 25,
          selectedPeriodType: paymentTypePresenter.selectedPeriod,
          pdfFileName: R.string.paymentsType,
          columnsWidths: const [100, 90, 50, 70, 70],
          columnIndexToCompareAndDetachBetterAndWorstValue: 1,
          fixFirstColumn: true,
          columnsIndexToSum: const [1, 2],
          titles: [
            PersonalizedTableCell(value: R.string.paymentsType, isTitle: true),
            PersonalizedTableCell(value: R.string.sales, isTitle: true),
            PersonalizedTableCell(
              value: R.string.quantityAbbreviated,
              isTitle: true,
            ),
            PersonalizedTableCell(value: R.string.ticketAverage, isTitle: true),
            PersonalizedTableCell(value: R.string.share, isTitle: true),
          ],
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
                  0,
                  (sum, s) => sum + (s.LiquidValue?.toDouble() ?? 1),
                );
                final totalQuantity = sales.fold<int>(
                  0,
                  (sum, s) => sum + (s.QuantitySales?.toInt() ?? 1),
                );
                final overallValue = widget.saleStatistics
                    .toList()
                    .sumLiquidValue();

                return [
                  PersonalizedTableCell(value: modality),
                  PersonalizedTableCell(value: totalValue, isMoney: true),
                  PersonalizedTableCell(value: totalQuantity),
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
