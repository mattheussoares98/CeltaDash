import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class SaleSection extends StatelessWidget {
  final SaleMovementCollectionItemViewModel sale;

  const SaleSection({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: R.string.sale,
      children: [
        Enterprise(sale: sale), // Assuming this is a styled widget
        DetailRow(
          title: "${R.string.date} ${R.string.sale.toLowerCase()}",
          value: sale.dateHourOfBilling,
        ),
        DetailRow(title: R.string.cashierNumber, value: sale.cashierNumber),
        DetailRow(title: R.string.coupon, value: sale.documentNumber),
        DetailRow(title: R.string.type, value: sale.fiscalNoteType?.Name),

        DetailRow(title: R.string.customer, value: sale.customer?.Name),

        DetailRow(title: R.string.cpfCnpj, value: sale.customer?.CpfCnpj),
        if (sale.seller != null)
          DetailRow(
            title: R.string.seller,
            value: "${sale.seller?.PersonalizedCode} - ${sale.seller?.Name}",
          ),
        DetailRow(
          title: R.string.total,
          value: sale.totalLiquid
              .toString()
              .toBRL()
              .addBrazilianCoin(),
        ),
      ],
    );
  }
}
