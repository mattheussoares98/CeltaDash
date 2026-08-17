import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupOfStoresContent extends StatelessWidget {
  const GroupOfStoresContent({super.key, required this.stores});

  final GroupOfStoresState stores;

  @override
  Widget build(BuildContext context) {
    final topStores = stores.enterprises.take(4);
    final otherStores = stores.enterprises.skip(4);
    final parameters = [
      ...topStores.map(
        (enterprise) => PieParameter(
          value: enterprise.liquidValue,
          title: BaseText.title(enterprise.name),
          subtitle: BaseRichText(
            texts: [
              BaseText.caption('R\$ '),
              BaseText(enterprise.liquidValue.toString().toBrazilianNumber()),
            ],
          ),
        ),
      ),
      if (otherStores.isNotEmpty)
        PieParameter(
          value: otherStores.fold(
            0,
            (total, enterprise) => total + enterprise.liquidValue,
          ),
          title: BaseText.title('Outras empresas'.hardcoded),
          subtitle: BaseRichText(
            texts: [
              BaseText.caption('R\$ '),
              BaseText(
                otherStores
                    .fold(
                      0.0,
                      (total, enterprise) => total + enterprise.liquidValue,
                    )
                    .toString()
                    .toBrazilianNumber(),
              ),
            ],
          ),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            BaseText.titleLarge(
              'Vendas do grupo'.hardcoded.toUpperCase(),
              textAlign: .center,
            ),
            ChartPieWidget(
              paddingItems: .zero,
              pieParameters: parameters,
              rightFlex: 55,
              leftFlex: 45,
            ),
            PrimaryButton(
              onPressed: () => context.pushNamed(Routes.groupSummary.name),
              text: 'Resumo do grupo'.hardcoded,
            ),
          ],
        ),
      ),
    );
  }
}
