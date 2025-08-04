import 'package:flutter/cupertino.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class FinalizationSection extends StatelessWidget {
  final SaleMovementCollectionItemViewModel sale;

  const FinalizationSection({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    if (sale.paymentFinalizations == null ||
        sale.paymentFinalizations!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SectionCard(
      title: R.string.finalizations,
      children: sale.paymentFinalizations!.map((e) {
        final portions = (e.QuantityOfPortions?.toString().toInt() ?? 0) <= 1
            ? ""
            : e.QuantityOfPortions!.toString().toBrazilianNumber(0);

        return Column(
          children: [
            DetailRow(
              title:
                  "${e.Finalization?.Name} ${portions.isEmpty ? "" : " (${portions}x)"}",
              value: e.Value.toString().toBrazilianNumber().addBrazilianCoin(),
            ),
          ],
        );
      }).toList(),
    );
  }
}
