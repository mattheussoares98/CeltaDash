// lib/features/home/presentation/pages/financial/resume/components/daily_progress/financial_daily_progress_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class FinancialDailyProgressContent extends StatelessWidget {
  const FinancialDailyProgressContent({
    super.key,
    required this.selectedDate,
    required this.receiveValue,
    required this.payValue,
  });

  final DateTime selectedDate;
  final double receiveValue;
  final double payValue;

  @override
  Widget build(BuildContext context) {
    final balance = receiveValue - payValue;
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;
    final payColor = balance < 0 ? Colors.red : Colors.amber;
    final receiveColor = balance < 0 ? Colors.amber : Colors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.titleLarge(
              'Títulos do dia'.hardcoded.toUpperCase(),
              textAlign: TextAlign.center,
            ),
            ChartPieWidget(
              centerPassedColor: context.theme.disabledColor.withAlpha(40),
              centerRemainingColor: context.theme.colorScheme.surface,
              showTotalAmount: payValue > 0 && receiveValue > 0,
              pieParameters: [
                PieParameter(
                  value: payValue,
                  color: payColor,
                  title: BaseText.titleMedium('A pagar'.hardcoded),
                  subtitle: _CurrencyValue(value: payValue, color: payColor),
                ),
                PieParameter(
                  value: receiveValue,
                  color: receiveColor,
                  title: BaseText.titleMedium('A receber'.hardcoded),
                  subtitle: _CurrencyValue(
                    value: receiveValue,
                    color: receiveColor,
                  ),
                ),
              ],
            ),
            Center(
              child: _CurrencyValue(
                value: balance,
                color: balanceColor,
                text: 'Saldo'.hardcoded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyValue extends StatelessWidget {
  const _CurrencyValue({this.text, required this.value, this.color});
  final String? text;
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BaseRichText(
      color: color,
      texts: [
        if (text != null) BaseText.bodyLarge('$text '.hardcoded),
        const BaseText('R\$ '),
        BaseText.titleLarge(value.toString().toBRL()),
      ],
    );
  }
}
