import 'package:flutter/cupertino.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class FinalizationSection extends StatelessWidget {
  final SaleMovementViewModel sale;

  const FinalizationSection({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    if (sale.paymentFinalizations == null ||
        sale.paymentFinalizations!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SectionCard(
      title: R.string.finalizations,
      children: sale.paymentFinalizations!
          .map((e) => Column(
                children: [
                  DetailRow(
                    title: R.string.finalization,
                    value: e.Finalization?.Name,
                  ),
                  if (e.QuantityOfPortions != null)
                    DetailRow(
                      title: R.string.quantityOfPortions,
                      value:
                          e.QuantityOfPortions.toString().toBrazilianNumber(),
                    ),
                  DetailRow(
                    title: R.string.total,
                    value: e.Value.toString()
                        .toBrazilianNumber()
                        .addBrazilianCoin(),
                  ),
                ],
              ))
          .toList(),
    );
  }
}
