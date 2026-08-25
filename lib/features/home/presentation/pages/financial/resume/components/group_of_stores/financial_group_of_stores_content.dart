// lib/features/home/presentation/pages/financial/resume/components/group_of_stores/financial_group_of_stores_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinancialGroupOfStoresContent extends StatelessWidget {
  const FinancialGroupOfStoresContent({super.key, required this.stores});

  final FinancialGroupOfStoresState stores;

  @override
  Widget build(BuildContext context) {
    final topStores = stores.enterprises.take(4);
    final otherStores = stores.enterprises.skip(4);

    final parameters = [
      ...topStores.map(
        (enterprise) => PieParameter(
          value: enterprise.totalVolume > 0 ? enterprise.totalVolume : 1.0,
          title: BaseText.title(enterprise.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseRichText(
                texts: [
                  BaseText.caption('Rec: '.hardcoded),
                  BaseText.caption(
                    enterprise.receiveLiquidValue
                        .toString()
                        .toBRL()
                        .addBrazilianCoin(),
                  ),
                ],
              ),
              BaseRichText(
                texts: [
                  BaseText.caption('Pag: '.hardcoded),
                  BaseText.caption(
                    enterprise.payLiquidValue
                        .toString()
                        .toBRL()
                        .addBrazilianCoin(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      if (otherStores.isNotEmpty)
        PieParameter(
          value: otherStores.fold<double>(
            0,
            (total, enterprise) => total + enterprise.totalVolume,
          ),
          title: BaseText.title('Outras empresas'.hardcoded),
          subtitle: BaseRichText(
            texts: [
              BaseText.caption('Total: '.hardcoded),
              BaseText.caption(
                otherStores
                    .fold<double>(
                      0,
                      (total, enterprise) => total + enterprise.totalVolume,
                    )
                    .toString()
                    .toBRL()
                    .addBrazilianCoin(),
              ),
            ],
          ),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.titleLarge(
              'Financeiro do grupo'.hardcoded.toUpperCase(),
              textAlign: TextAlign.center,
            ),
            ChartPieWidget(
              paddingItems: EdgeInsets.zero,
              pieParameters: parameters,
              rightFlex: 55,
              leftFlex: 45,
            ),
            gapH8,
            PrimaryButton(
              onPressed: () => context.goNamed(Routes.financialHomePeriods.name),
              text: 'Ver movimentação'.hardcoded,
            ),
          ],
        ),
      ),
    );
  }
}
