import 'dart:math';

import 'package:celta_plus/ui/components/chart_prices.dart';
import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import 'components.dart';

class MonthlyAnalysis extends StatelessWidget {
  const MonthlyAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.decoration,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            "" + "Análise mensal",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("" + "Tendência de vendas"),
                    Text(
                      1109131.25
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    Text("" + "Venda média diária"),
                    Text(
                      35778.43
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CompareTimesResult(
            betterTime: "21/03",
            worstTime: "24/04",
            betterValue: 53073.79,
            worstValue: 9624.39,
            betterTimeMessage: "" + "Melhor dia do mês",
            worstTimeMessage: "" + "Pior dia do mês",
          ),
          const SizedBox(height: 8),
          ChartPrices(
            datesAndValues: List.generate(30, (index) {
              //TODO get by external api
              int day = index + 1;
              return DateAndValue(
                value: double.parse(
                  (Random().nextDouble() * 1000000).toStringAsFixed(2),
                ),
                date: DateTime(2025, 3, day),
              );
            }),
          ),
        ],
      ),
    );
  }
}
