import 'package:flutter/material.dart';

import '../../pages.dart';

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
            Text(product?.Id ?? ""),
            Text(product?.IsCancelled ?? ""),
            Text(product?.LiquidCost ?? ""),
            Text(product?.ProductPackingId ?? ""),
            Text(product?.Quantity ?? ""),
            Text(product?.RepositionCost ?? ""),
            Text(product?.TotalBrute ?? ""),
            Text(product?.TotalDiscounts ?? ""),
            Text(product?.TotalLiquid ?? ""),
            Text(product?.UnitValue ?? ""),
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
