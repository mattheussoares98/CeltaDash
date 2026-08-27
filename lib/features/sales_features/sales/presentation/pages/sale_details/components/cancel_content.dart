import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/sales/domain/domain.dart';
import 'package:celta_dash/features/sales_features/sales/presentation/pages/sale_details/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class CancelContent extends StatelessWidget {
  const CancelContent({super.key, required this.sale});

  final SaleMovementCollectionItemEntity sale;

  @override
  Widget build(BuildContext context) {
    if (sale.isCancelled != true) {
      return const SizedBox.shrink();
    }

    return BaseSaleTitleAndContent(
      title: 'Cancelamento'.hardcoded,
      content: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (sale.dateHourOfCancellation != null)
            TitleAndSubTitle(
              title: 'Data'.hardcoded,
              subTitle: sale.dateHourOfCancellation?.formatDate(
                .ddMMyyyyHHmmss,
              ),
            ),
          if (sale.userCancellation?.isNotEmpty ?? false)
            TitleAndSubTitle(
              title: 'Cancelada por'.hardcoded,
              subTitle: sale.userCancellation,
            ),
          if (sale.motiveCancellation?.isNotEmpty ?? false)
            TitleAndSubTitle(
              title: 'Justificativa'.hardcoded,
              subTitle: sale.motiveCancellation,
            ),
        ],
      ),
    );
  }
}
