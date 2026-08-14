import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';

class FinancialTitleDailySummary extends StatelessWidget {
  final List<FinancialTitleDataEntity> rows;
  final DateTime? loadedAt;
  final VoidCallback reload;

  const FinancialTitleDailySummary({
    super.key,
    required this.rows,
    required this.loadedAt,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nenhum titulo financeiro no periodo.'), //TODO hardcoded
            TextButton(onPressed: reload, child: Text(R.string.reload))
          ],
        ),
      );
    }

    final receiveValue = rows.fold<double>(
      0,
      (total, row) => total + (row.receiveOpenValue ?? 0).toDouble(),
    );
    final payValue = rows.fold<double>(
      0,
      (total, row) => total + (row.payOpenValue ?? 0).toDouble(),
    );

    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'TÍULOS DO DIA', //TODO use hardcoded
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 8), //TODO use gap
          ChartPieWidget(
            showTotalAmount: false,
            centerPassedColor: Colors.grey,
            centerRemainingColor: Colors.white,
            pieParameters: [
              PieParameter(
                value: receiveValue,
                color: Colors.green,
                title: Text(
                  //TODO create BaseText
                  'A receber', //TODO use hardcoded
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall, //TODO create theme extension
                ),
                subtitle: Text(
                  currency.format(receiveValue),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.green),
                ),
              ),
              PieParameter(
                value: payValue,
                color: Colors.red,
                title: Text(
                  'A pagar', //TODO use hardcoded
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Text(
                  currency.format(payValue),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), //TODO use gap
          Text(
            'Saldo ${currency.format(receiveValue - payValue)}', //TODO hardcoded
            style: Theme.of(context) //TODO add title and subtitle
                .textTheme
                .titleMedium
                ?.copyWith(
                    color: (receiveValue - payValue) > 0
                        ? Colors.green
                        : Colors.red),
          ),
        ],
      ),
    );
  }
}
