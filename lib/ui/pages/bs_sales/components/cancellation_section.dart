import 'package:flutter/cupertino.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class CancellationSection extends StatelessWidget {
  final SaleMovementCollectionItemViewModel sale;
  const CancellationSection({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    if (sale.dateHourOfCancellation == null) {
      return const SizedBox.shrink();
    }
    return SectionCard(
      title: R.string.cancellation,
      children: [
        DetailRow(
          title:
              "${R.string.date} ${R.string.cancellationAbbreviated.toLowerCase()}",
          value: sale.dateHourOfCancellation,
        ),
        DetailRow(
          title: R.string.cancelledBy,
          value: sale.userCancellation,
        ),
        DetailRow(
          title: R.string.justification,
          value: sale.motiveCancellation,
        ),
      ],
    );
  }
}
