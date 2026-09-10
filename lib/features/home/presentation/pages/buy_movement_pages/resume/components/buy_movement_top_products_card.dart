import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementTopProductsCard extends ConsumerWidget {
  const BuyMovementTopProductsCard({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeBuyMovementProductsControllerProvider(
      enterpriseId,
      HomeBuyMovementPeriod.hourly,
    );
    return AsyncValueWidget(
      value: ref.watch(provider),
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (rows) => Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseText.titleLarge(
                'Produtos mais comprados'.hardcoded.toUpperCase(),
                textAlign: TextAlign.center,
              ),
              gapH8,
              if (rows.isEmpty)
                BaseText(
                  'Nenhum produto encontrado'.hardcoded,
                  textAlign: TextAlign.center,
                )
              else
                for (final row in rows.take(10))
                  TitleAndSubTitle(
                    title: row.product?.name ?? '',
                    subTitle: row.totalValue
                        .toString()
                        .toBRL()
                        .addBrazilianCoin(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
