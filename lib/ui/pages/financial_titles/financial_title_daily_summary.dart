import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';

class FinancialTitleDailySummary extends StatelessWidget {
  final List<FinancialTitleDataEntity> rows;
  final VoidCallback reload;

  const FinancialTitleDailySummary({
    super.key,
    required this.rows,
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
            const Text('Nenhum titulo financeiro no periodo.'),
            TextButton(onPressed: reload, child: Text(R.string.reload))
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final row = rows[index];
        final date = row.date;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  date == null ? '-' : DateFormat('dd/MM/yyyy').format(date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                    'A receber: ${currency.format(row.receiveOpenValue ?? 0)}'),
                Text('A pagar: ${currency.format(row.payOpenValue ?? 0)}'),
                Text('Saldo: ${currency.format(row.openBalanceValue ?? 0)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
