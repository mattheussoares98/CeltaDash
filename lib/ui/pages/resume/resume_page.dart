import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/models.dart';
import '../../../ui/helpers/helpers.dart';
import 'components/components.dart';
import 'resume.dart';

class ResumePage extends StatefulWidget {
  final ResumePresenter resumePresenter;
  const ResumePage({super.key, required this.resumePresenter});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  final DailySalesModel dailySalesModel = DailySalesModel(
    salesQuantity: Random().nextInt(1000),
    totalAmountInDay: Random().nextDouble() * 50000,
    productsAverageBySale: Random().nextDouble() * 10,
  );

  final quantityOfDaysInMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableProvider(
        create: (_) => widget.resumePresenter,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SalesInformations(
                  scrollController: scrollController,
                  title: "Sales of the day" + "",
                  totalSales: dailySalesModel.totalAmountInDay,
                  leftButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToPaymentsTypePage,
                    title: "" + "Tipos de pagamento",
                  ),
                  rightButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToSectionsPage,
                    title: "" + "Seções",
                  ),
                  goal: Random().nextDouble() * 50000,
                  children: [
                    Text(
                      "" + "Sales quantity\n${dailySalesModel.salesQuantity}",
                    ),
                    Text(
                      "" +
                          "Ticket avarage (R\$)\n${(dailySalesModel.totalAmountInDay / dailySalesModel.salesQuantity).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                    Text(
                      "" +
                          "Products by sale\n${dailySalesModel.productsAverageBySale.toString().toBrazilianNumber()}",
                    ),
                    Text(
                      "" +
                          "Average price (R\$)\n${(dailySalesModel.totalAmountInDay / dailySalesModel.salesQuantity / dailySalesModel.productsAverageBySale).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SalesInformations(
                  scrollController: scrollController,
                  goal: Random().nextDouble() * 50000 * quantityOfDaysInMonth,
                  totalSales:
                      Random().nextDouble() * 50000 * quantityOfDaysInMonth,
                  title: "Sales of the month" + "",
                  leftButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToSetGoalPage,
                    title: "" + "Inserir meta",
                  ),

                  rightButton: DefaultNavigateButton(
                    onTap:
                        widget
                            .resumePresenter
                            .goToSetGoalPage, //TODO add new function
                    title: "" + "Histórico de metas",
                  ),
                  children: [
                    Text(
                      "" +
                          "Sales until now\n${(Random().nextDouble() * 30000).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ProfitabilityButton(),
                const SizedBox(height: 8),
                DailyAnalysis(),
                SizedBox(height: 8),
                MonthlyAnalysis(),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
