import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentFinalizations extends StatelessWidget {
  const PaymentFinalizations({
    super.key,
    required this.sale,
  });

  final EcSaleMovementViewModel? sale;

  @override
  Widget build(BuildContext context) {
    if (sale?.paymentFinalizations?.isEmpty == true) {
      return SizedBox();
    }

    return Column(
      children: [
        TableItem(
          titleMinHeight: 30,
          titles: [
            PersonalizedTableCell(value: R.string.finalization),
            PersonalizedTableCell(value: R.string.portions),
            PersonalizedTableCell(value: R.string.total),
          ],
          rowValues: sale!.paymentFinalizations!.map((e) {
            return [
              PersonalizedTableCell(value: e.Finalization?.Name),
              PersonalizedTableCell(value: e.QuantityOfPortions),
              PersonalizedTableCell(value: e.Value?.toDouble(), isMoney: true),
            ];
          }).toList(),
        ),
      ],
    );
  }
}
