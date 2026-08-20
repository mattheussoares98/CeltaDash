import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/sales/presentation/pages/sale_details/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class FinalizationsContent extends StatelessWidget {
  const FinalizationsContent({super.key, required this.sale});
  final SaleMovementCollectionItemEntity sale;

  @override
  Widget build(BuildContext context) {
    final finalizations = sale.paymentFinalizations ?? [];
    if (finalizations.isEmpty) {
      return const SizedBox.shrink();
    }
    return BaseSaleTitleAndContent(
      title: 'Finalizadoras'.hardcoded,
      content: Column(
        crossAxisAlignment: .stretch,
        children: finalizations
            .map(
              (e) => TitleAndSubTitle(
                title: e.Finalization?.Name ?? '-'.hardcoded,
                subTitle: (e.Value ?? 0).toString().toBRL(),
                subTitleIsPrice: true,
              ),
            )
            .toList(),
      ),
    );
  }
}
