import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementGroupOfStoresCard extends ConsumerWidget {
  const BuyMovementGroupOfStoresCard({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = buyMovementGroupOfStoresControllerProvider(enterpriseId);
    return AsyncValueWidget(
      value: ref.watch(provider),
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (state) {
        if (!state.hasMultipleEnterprises) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BaseText.titleLarge(
                  'Compras do grupo'.hardcoded.toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                ChartPieWidget(
                  paddingItems: EdgeInsets.zero,
                  pieParameters: state.enterprises
                      .map(
                        (item) => PieParameter(
                          value: item.totalValue.toDouble(),
                          title: BaseText.bodySmall(
                            item.name,
                            fontWeight: FontWeight.bold,
                          ),
                          subtitle: BaseText.caption(
                            item.totalValue
                                .toString()
                                .toBRL()
                                .addBrazilianCoin(),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
