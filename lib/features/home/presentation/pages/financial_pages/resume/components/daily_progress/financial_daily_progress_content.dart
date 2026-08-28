// lib/features/home/presentation/pages/financial/resume/components/daily_progress/financial_daily_progress_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class FinancialDailyProgressContent extends StatelessWidget {
  const FinancialDailyProgressContent({
    super.key,
    required this.selectedDate,
    required this.payOpenValue,
    required this.paySettledValue,
    required this.receiveOpenValue,
    required this.receiveSettledValue,
  });

  final DateTime selectedDate;
  final double payOpenValue;
  final double paySettledValue;
  final double receiveOpenValue;
  final double receiveSettledValue;

  @override
  Widget build(BuildContext context) {
    final totalReceive = receiveOpenValue + receiveSettledValue;
    final totalPay = payOpenValue + paySettledValue;
    final balance = totalReceive - totalPay;
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;

    const payOpenColor = Colors.orange;
    const paySettledColor = Colors.red;
    const receiveOpenColor = Colors.blue;
    const receiveSettledColor = Colors.green;

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
              paddingItems: EdgeInsets.zero,
              leftFlex: 45,
              rightFlex: 55,
              centerPassedColor: context.theme.disabledColor.withAlpha(40),
              centerRemainingColor: context.theme.colorScheme.surface,
              showTotalAmount: (totalPay + totalReceive) > 0,
              pieParameters: [
                PieParameter(
                  value: payOpenValue,
                  color: payOpenColor,
                  title: BaseText.bodySmall(
                    'Pagar (aberto)'.hardcoded,
                    fontWeight: .bold,
                  ),
                  subtitle: _CurrencyValue(
                    value: payOpenValue,
                    color: payOpenColor,
                  ),
                ),
                PieParameter(
                  value: paySettledValue,
                  color: paySettledColor,
                  title: BaseText.bodySmall(
                    'Pagar (liquidado)'.hardcoded,
                    fontWeight: .bold,
                  ),
                  subtitle: _CurrencyValue(
                    value: paySettledValue,
                    color: paySettledColor,
                  ),
                ),
                PieParameter(
                  value: receiveOpenValue,
                  color: receiveOpenColor,
                  title: BaseText.bodySmall(
                    'Receber (aberto)'.hardcoded,
                    fontWeight: .bold,
                  ),
                  subtitle: _CurrencyValue(
                    value: receiveOpenValue,
                    color: receiveOpenColor,
                  ),
                ),
                PieParameter(
                  value: receiveSettledValue,
                  color: receiveSettledColor,
                  title: BaseText.bodySmall(
                    'Receber (liquidado)'.hardcoded,
                    fontWeight: .bold,
                  ),
                  subtitle: _CurrencyValue(
                    value: receiveSettledValue,
                    color: receiveSettledColor,
                  ),
                ),
              ],
            ),
            Center(
              child: _CurrencyValue(
                value: balance,
                color: balanceColor,
                text: 'Saldo'.hardcoded,
                isLarge: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyValue extends StatelessWidget {
  const _CurrencyValue({
    this.text,
    required this.value,
    this.color,
    this.isLarge = false,
  });

  final String? text;
  final double value;
  final Color? color;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return BaseRichText(
      color: color,
      texts: [
        if (text != null)
          isLarge
              ? BaseText.bodyLarge('$text '.hardcoded)
              : BaseText.caption('$text '.hardcoded),
        if (isLarge) const BaseText('R\$ ') else BaseText.caption('R\$ '),
        if (isLarge)
          BaseText.titleLarge(value.toString().toBRL())
        else
          BaseText.bodySmall(
            value.toString().toBRL(),
            fontWeight: .bold,
          ),
      ],
    );
  }
}
