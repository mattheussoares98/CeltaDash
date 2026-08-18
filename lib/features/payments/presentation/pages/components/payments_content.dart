import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/payments/presentation/presentation.dart';
import 'package:celta_dash/ui/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentsContent extends HookConsumerWidget {
  const PaymentsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(PaymentsPeriod.daily);
    final provider = paymentsControllerProvider(selectedPeriod.value);
    final statisticsAsync = ref.watch(provider);

    final reloadButton = ReloadIconButton(refreshProviders: [provider]);
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return BaseScaffold(
      appBar: HomeAppBar(
        isLandscape: isLandscape,
        reloadButton: reloadButton,
        showLeading: true,
      ),
      isScrollable: false,
      usePadding: false,
      body: Column(
        children: [
          NewBaseSegmentedButtons(
            items: PaymentsPeriod.values,
            selectedValue: selectedPeriod.value,
            onChanged: (value) => selectedPeriod.value = value,
            itemLabelBuilder: (value) => value.label,
          ),
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  DefaultTabBar(
                    tabs: [
                      DefaultTab(
                        title: 'Modalidades'.hardcoded,
                        materialIcon: Icons.credit_card,
                        cupertinoIcon: CupertinoIcons.creditcard,
                      ),
                      DefaultTab(
                        title: 'Finalizadoras'.hardcoded,
                        materialIcon: Icons.receipt_long,
                        cupertinoIcon: CupertinoIcons.list_bullet,
                      ),
                    ],
                  ),
                  Expanded(
                    child: AsyncValueWidget(
                      value: statisticsAsync,
                      preserveValue: true,
                      tryAgain: () => ref.invalidate(provider),
                      data: (statistics) => statistics.isEmpty
                          ? Center(
                              child: BaseText(
                                'Nenhuma venda encontrada'.hardcoded,
                              ),
                            )
                          : TabBarView(
                              children: [
                                PaymentsStatisticsTable(
                                  saleStatistics: statistics,
                                  filterByFinalizations: false,
                                ),
                                PaymentsStatisticsTable(
                                  saleStatistics: statistics,
                                  filterByFinalizations: true,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
