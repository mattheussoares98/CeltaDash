import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class Products extends StatelessWidget {
  const Products({
    super.key,
    required this.sale,
  });

  final EcSaleMovementViewModel? sale;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sale?.products?.length,
      itemBuilder: (context, index) {
        final product = sale?.products![index];
        return Column(
          children: [
            TitleAndValue(
              title: R.string.cost,
              value: product?.LiquidCost,
            ),
            TitleAndValue(
              title: R.string.quantityAbbreviated,
              value: product?.Quantity,
            ),
            Text(product?.UnitValue ?? ""),
            if ((product?.TotalDiscounts?.toDouble() ?? 0) > 0)
              TitleAndValue(
                title: R.string.discounts,
                value: product?.TotalDiscounts,
              ),
              //TODO use the TableItem here
            // Text(product?.RepositionCost ?? ""),
            // Text(product?.TotalBrute ?? ""),
            TitleAndValue(
              title: R.string.total,
              value: product?.TotalLiquid,
            ),
            Text(product?.UnitValueLiquid ?? ""),
            Text(product?.Product?.Name ?? ""),
            Text(product?.Product?.PackingAbbreviation ?? ""),
            Text(product?.Product?.PackingQuantity ?? ""),
            Text(product?.Product?.Plu ?? ""),
          ],
        );
      },
    );
  }
}
