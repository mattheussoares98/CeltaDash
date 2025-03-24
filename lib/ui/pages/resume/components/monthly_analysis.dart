import 'dart:math';

import 'package:celta_plus/ui/components/chart_prices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/models.dart';
import '../../../../ui/helpers/helpers.dart';
import 'components.dart';

class MonthlyAnalysis extends StatelessWidget {
  const MonthlyAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    List<DateAndValueModel> datesAndValues = List.generate(31, (index) {
      //TODO get by external api
      int day = index + 1;
      return DateAndValueModel(
        value: double.parse(
          (Random().nextDouble() * 50000).toStringAsFixed(2),
        ),
        date: DateTime(2025, 3, day),
      );
    });

    final betterValue = datesAndValues.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    final worstValue = datesAndValues.reduce(
      (a, b) => a.value < b.value ? a : b,
    );

    final averageValue =
        datesAndValues.fold(
          0.0,
          (previous, element) => previous + element.value,
        ) /
        datesAndValues.length;

    int daysInCurrentMonth =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;

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
                      (averageValue * daysInCurrentMonth)
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
                      averageValue
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
            betterTime: DateFormat("dd/MM").format(betterValue.date),
            worstTime: DateFormat("dd/MM").format(worstValue.date),
            betterValue: betterValue.value,
            worstValue: worstValue.value,
            betterTimeMessage: "" + "Melhor dia do mês",
            worstTimeMessage: "" + "Pior dia do mês",
          ),
          const SizedBox(height: 8),
          ChartPrices(datesAndValues: datesAndValues),
        ],
      ),
    );
  }
}
