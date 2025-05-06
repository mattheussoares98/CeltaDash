import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class GroupSummaryPage extends StatefulWidget {
  const GroupSummaryPage({super.key});

  @override
  State<GroupSummaryPage> createState() => _GroupSummaryPageState();
}

class _GroupSummaryPageState extends State<GroupSummaryPage> {
  bool selectedDay = true;

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      appBar: DefaultAppBar(
        showEnterpriseDropdown: false,
        onChangeDateOrEnterprise: () async {
          await resumePresenter.getSales(homePresenter);
        },
      ),
      body: Obx(() {
        final saleMovements = resumePresenter.saleMovements;

        if (saleMovements == null || saleMovements.isEmpty) {
          return ElevatedButton(
            onPressed: () async {
              await resumePresenter.getSales(homePresenter);
            },
            child: Text(R.string.searchAgain),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${homePresenter.enterprises?.length ?? 1} ${R.string.enterprises}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectPeriodItems(
                      items: [
                        SelectPeriodItems.createItem(
                          title: R.string.day,
                          onTap: () {
                            setState(() {
                              selectedDay = true;
                            });
                          },
                        ),
                        SelectPeriodItems.createItem(
                          title: R.string.month,
                          onTap: () {
                            setState(() {
                              selectedDay = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  final groupSales = saleMovements
                      .filteredSales(
                        filterDay:
                            selectedDay ? homePresenter.selectedDate.day : null,
                      )
                      .map((e) => e.toViewModel())
                      .toList();

                  final groupSalesTotalLiquid = groupSales.sumLiquidValue();
                  int groupSalesQuantity = groupSales.quantitySales();

                  return Column(
                    children: [
                      Indicator(
                        firstTitle: R.string.totalSalesGroup,
                        secondTitle: R.string.averageSalesGroup,
                        firstValue: groupSalesTotalLiquid
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        secondValue: (groupSalesTotalLiquid /
                                (homePresenter.enterprises?.length ?? 1))
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        icon: Icons.monetization_on,
                      ),
                      const SizedBox(height: 4),
                      Indicator(
                        firstTitle: R.string.salesQuantity,
                        secondTitle: R.string.salesQuantityAverage,
                        firstValue: groupSales.quantitySales().toString(),
                        secondValue: (groupSalesQuantity /
                                (homePresenter.enterprises?.length ?? 1))
                            .toString()
                            .toBrazilianNumber(),
                        icon: Icons.person,
                      ),
                      //TODO add averate ticket by sale and devolutions
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
