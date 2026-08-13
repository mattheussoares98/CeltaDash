import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../ui/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';
import 'pie.dart';

class PersonalizedPieChart extends StatelessWidget {
  const PersonalizedPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return Obx(() {
      final sales = personalizedPresenter.saleStatistics;
      if (sales == null || sales.isEmpty) {
        return const SizedBox.shrink();
      }

      sales.sort(
        (saleA, saleB) => saleB.LiquidValue!.compareTo(saleA.LiquidValue!),
      );
      final topFour = sales.take(4);
      final othersTotal = sales
          .skip(4)
          .fold<double>(
            0.0,
            (sum, e) => sum + (e.LiquidValue?.toDouble() ?? 0),
          );

      return Container(
        decoration: ContainerDecoration.defaultDecoration,
        child: ChartPieWidget(
          pieParameters: [
            ...topFour.map(
              (e) => PieParameter(
                value: e.LiquidValue?.toDouble() ?? 0,
                title: PersonalizedPieTitle(sale: e),
                subtitle: Text(
                  e.LiquidValue?.toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin() ??
                      '',
                ),
              ),
            ),
            if (othersTotal > 0)
              PieParameter(
                value: othersTotal,
                title: Text(
                  R.string.anothers,
                  style: theme.textTheme.titleSmall,
                ),
                subtitle: Text(
                  othersTotal.toString().toBrazilianNumber().addBrazilianCoin(),
                ),
              ),
          ],
        ),
      );
    });
  }
}
