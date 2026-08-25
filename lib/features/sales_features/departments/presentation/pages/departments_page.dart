// lib/features/departments/presentation/pages/departments_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/departments/presentation/presentation.dart';
import 'package:celta_dash/ui/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      builder: (context, enterpriseId) =>
          _DepartmentsContent(enterpriseId: enterpriseId),
    );
  }
}

class _DepartmentsContent extends HookConsumerWidget {
  const _DepartmentsContent({required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(DepartmentsPeriod.daily);
    final provider = departmentsControllerProvider(
      enterpriseId,
      selectedPeriod.value,
    );

    final reloadButton = ReloadIconButton(refreshProviders: [provider]);
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return BaseScaffold(
      appBar: HomeAppBar(
        isLandscape: isLandscape,
        reloadButton: reloadButton,
        leading: BaseIconButton(
          onPressed: Navigator.of(context).pop,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.back,
            materialIcon: Icons.arrow_back,
          ),
        ),
      ),
      isScrollable: false,
      usePadding: false,
      body: Column(
        children: [
          NewBaseSegmentedButtons(
            items: DepartmentsPeriod.values,
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
                        title: 'Departamentos'.hardcoded,
                        materialIcon: Icons.apartment,
                        cupertinoIcon: CupertinoIcons.building_2_fill,
                      ),
                      DefaultTab(
                        title: 'Seções'.hardcoded,
                        materialIcon: Icons.view_module,
                        cupertinoIcon: CupertinoIcons.square_grid_2x2,
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
                                    DepartmentsStatisticsTable(
                                      saleStatistics: statistics,
                                      isLoading: statisticsAsync.isLoading,
                                    ),
                                    SectionsStatisticsTable(
                                      saleStatistics: statistics,
                                      isLoading: statisticsAsync.isLoading,
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
