import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/departments/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementDepartmentsContent extends HookConsumerWidget {
  const BuyMovementDepartmentsContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(BuyMovementDepartmentsPeriod.daily);
    final provider = homeBuyMovementDepartmentsControllerProvider(
      enterpriseId,
      selectedPeriod.value,
    );
    final rows = ref.watch(provider);

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      appBar: HomeAppBar(
        isLandscape: MediaQuery.orientationOf(context) == Orientation.landscape,
        reloadButton: ReloadIconButton(refreshProviders: [provider]),
        leading: BaseIconButton(
          onPressed: Navigator.of(context).pop,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.back,
            materialIcon: Icons.arrow_back,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: NewBaseSegmentedButtons<BuyMovementDepartmentsPeriod>(
              items: BuyMovementDepartmentsPeriod.values,
              selectedValue: selectedPeriod.value,
              onChanged: (period) => selectedPeriod.value = period,
              itemLabelBuilder: (period) => period.label,
            ),
          ),
          Expanded(
            child: AsyncValueWidget(
              value: rows,
              preserveValue: true,
              tryAgain: () => ref.invalidate(provider),
              data: (data) => data.isEmpty
                  ? Center(
                      child: BaseText('Nenhuma compra encontrada'.hardcoded),
                    )
                  : BuyMovementDepartmentsTable(
                      rows: data,
                      refreshProvider: provider,
                      isLoading: rows.isLoading,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
