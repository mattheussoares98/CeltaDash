// lib/features/home/presentation/pages/financial/resume/components/daily_progress/financial_daily_progress_content.dart
import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final total = receiveValue + payValue;
    final balance = receiveValue - payValue;
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.titleLarge(
              '${'Títulos do dia'.hardcoded.toUpperCase()} (${selectedDate.formatDate()})',
              textAlign: TextAlign.center,
            ),
            gapH16,
            LayoutBuilder(
              builder: (context, constraints) {
                final circleSize = min(
                  (constraints.maxWidth - Sizes.p16) / 2,
                  Sizes.p120,
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: AnimatedCircleProgress(
                        key: ValueKey('receive_${receiveValue}_$total'),
                        title: 'A receber'.hardcoded,
                        value: receiveValue,
                        maximum: total > 0
                            ? total
                            : (receiveValue > 0 ? receiveValue : 1),
                        height: circleSize,
                        width: circleSize,
                      ),
                    ),
                    gapW16,
                    Expanded(
                      child: AnimatedCircleProgress(
                        key: ValueKey('pay_${payValue}_$total'),
                        title: 'A pagar'.hardcoded,
                        value: payValue,
                        maximum: total > 0
                            ? total
                            : (payValue > 0 ? payValue : 1),
                        height: circleSize,
                        width: circleSize,
                      ),
                    ),
                  ],
                );
              },
            ),
            gapH16,
            Center(
              child: BaseRichText(
                texts: [
                  BaseText.bodyLarge('Saldo do dia: '.hardcoded),
                  BaseText.title(
                    balance.toString().toBRL().addBrazilianCoin(),
                    color: balanceColor,
                  ),
                ],
              ),
            ),
            gapH12,
            PrimaryButton(
              text: 'Ver movimentação'.hardcoded,
              onPressed: () => context.goNamed(Routes.financialHomePeriods.name),
            ),
          ],
        ),
      ),
    );
  }
}
