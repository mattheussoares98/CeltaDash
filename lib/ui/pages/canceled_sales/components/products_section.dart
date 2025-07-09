import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class ProductsSection extends StatelessWidget {
  final SaleMovementViewModel sale;
  const ProductsSection({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: R.string.products,
      children: List.generate(
        sale.products?.length ?? 0,
        (index) {
          final product = sale.products![index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: index == 0
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Text(
                              R.string.product,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(product.Product?.Name ?? ""),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          if (index == 0)
                            Text(
                              R.string.price,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(product.UnitValueLiquid?.toString()
                                  .toBrazilianNumber() ??
                              ""),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          if (index == 0)
                            Text(
                              R.string.quantityAbbreviated,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(product.Quantity?.toString().toBrazilianNumber(
                                  (product.Quantity?.toDouble() ?? 1) % 1 == 0
                                      ? 0
                                      : 2) ??
                              ""),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          if (index == 0)
                            Text(
                              R.string.total,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(product.TotalLiquid?.toString()
                                  .toBrazilianNumber() ??
                              ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 3),
              if (index == sale.products!.length - 1)
                Row(
                  children: [
                    const Expanded(
                      child: Text(""),
                    ),
                    Text(
                      sale.products!
                          .fold(0.0,
                              (p, e) => p + (e.TotalLiquid?.toDouble() ?? 0))
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
