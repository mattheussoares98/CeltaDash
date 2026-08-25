import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sales/presentation/pages/sale_details/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class SaleDetailsContent extends StatelessWidget {
  const SaleDetailsContent({required this.sale, super.key});

  final SaleMovementCollectionItemEntity sale;

  bool get _isCancellationInfoAvailable =>
      sale.dateHourOfCancellation != null ||
      (sale.userCancellation?.isNotEmpty ?? false) ||
      (sale.motiveCancellation?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    final items = [
      SaleContent(sale: sale),
      if (_isCancellationInfoAvailable) CancelContent(sale: sale),
      FinalizationsContent(sale: sale),
    ];

    final products = sale.products ?? const [];
    return CustomScrollView(
      slivers: [
        ResponsiveListFlow(
          padding: const EdgeInsets.all(Sizes.p8),
          isSliver: true,
          useMasonryLayout: false,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        ),

        if (products.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: BaseText.titleMedium(
              'Produtos'.hardcoded,
              color: context.theme.primaryColor,
            ),
          ),
          ResponsiveListFlow(
            padding: const EdgeInsets.all(Sizes.p8),
            isSliver: true,
            useMasonryLayout: false,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BaseText.title(
                        product.Product?.Name ?? 'Produto'.hardcoded,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                BaseText.title('Qtd'.hardcoded),
                                BaseText(
                                  product.Quantity?.toString().toBRL() ?? '0',
                                ),
                              ],
                            ),
                          ),
                          gapW4,
                          Expanded(
                            child: Column(
                              children: [
                                BaseRichText(
                                  texts: [
                                    BaseText.caption('R\$ '),
                                    BaseText.title('Preço'.hardcoded),
                                  ],
                                ),
                                BaseText(
                                  (product.UnitValueLiquid ?? 0)
                                      .toString()
                                      .toBRL(),
                                ),
                              ],
                            ),
                          ),
                          gapW4,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .end,
                              children: [
                                BaseRichText(
                                  texts: [
                                    BaseText.caption('R\$ '),
                                    BaseText.title('Total'.hardcoded),
                                  ],
                                ),
                                BaseText(
                                  (product.TotalLiquid ?? 0).toString().toBRL(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
