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
    double titleMinHeight = 30;
    double getFinalizationsHeight() {
      if (sale?.paymentFinalizations?.length == 1) {
        return titleMinHeight * 2 + 30;
      }
      return titleMinHeight * 2 + 60;
    }

    return SizedBox(
      height: getFinalizationsHeight(),
      child: Column(
        children: [
          TableItem(
            titleMinHeight: titleMinHeight,
            columnsIndexToSum: [2],
            titles: [
              PersonalizedTableCell(value: R.string.finalization),
              PersonalizedTableCell(value: R.string.portions),
              PersonalizedTableCell(value: R.string.total),
            ],
            rowValues: sale!.paymentFinalizations!.map((e) {
              return [
                PersonalizedTableCell(value: e.Finalization?.Name),
                PersonalizedTableCell(value: e.QuantityOfPortions),
                PersonalizedTableCell(
                    value: e.Value?.toDouble(), isMoney: true),
              ];
            }).toList(),
          ),
        ],
      ),
    );
  }
}
