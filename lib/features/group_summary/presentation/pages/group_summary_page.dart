// lib/features/group_summary/presentation/pages/group_summary_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/group_summary/presentation/presentation.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/ui/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupSummaryPage extends StatelessWidget {
  const GroupSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      builder: (context, enterpriseId) =>
          _GroupSummaryContent(enterpriseId: enterpriseId),
    );
  }
}

class _GroupSummaryContent extends HookConsumerWidget {
  const _GroupSummaryContent({required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(GroupSummaryPeriod.daily);
    final provider = groupSummaryControllerProvider(
      enterpriseId,
      selectedPeriod.value,
    );

    return BaseScaffold(
      appBar: HomeAppBar(
        isLandscape: true,
        reloadButton: ReloadIconButton(refreshProviders: [provider]),
        leading: BaseIconButton(
          onPressed: context.pop,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.back,
            materialIcon: Icons.arrow_back,
          ),
        ),
        showEnterpriseDropdown: false,
      ),
      isScrollable: false,
      usePadding: false,
      body: Column(
        children: [
          NewBaseSegmentedButtons(
            items: GroupSummaryPeriod.values,
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
                        title: 'Detalhes'.hardcoded,
                        materialIcon: Icons.bar_chart_rounded,
                        cupertinoIcon: CupertinoIcons.list_dash,
                      ),
                      DefaultTab(
                        title: 'Resumo'.hardcoded,
                        materialIcon: Icons.pie_chart,
                        cupertinoIcon: CupertinoIcons.chart_pie,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (_, ref, _) {
                        final statisticsAsync = ref.watch(provider);

                        return AsyncValueWidget(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    GroupSummaryDetailsTable(
                                      saleStatistics: statistics,
                                      isLoading: statisticsAsync.isLoading,
                                    ),
                                    GroupSummaryResumeTab(
                                      saleStatistics: statistics,
                                    ),
                                  ],
                                ),
                        );
                      },
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
