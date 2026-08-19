// lib/features/sellers/presentation/pages/components/sellers_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sellers/sellers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SellersContent extends HookConsumerWidget {
  const SellersContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(SellersPeriod.daily);
    final visitedPeriods = useState<Set<SellersPeriod>>({SellersPeriod.daily});

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      appBar: HomeAppBar(
        leading: BaseIconButton(
          onPressed: context.pop,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.back,
            materialIcon: Icons.arrow_back,
          ),
        ),
        isLandscape:
            MediaQuery.of(context).orientation == Orientation.landscape,
        reloadButton: ReloadIconButton(
          refreshProviders: [
            for (final period in SellersPeriod.values)
              if (visitedPeriods.value.contains(period))
                sellersControllerProvider(enterpriseId, period),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: NewBaseSegmentedButtons<SellersPeriod>(
              items: SellersPeriod.values,
              selectedValue: selectedPeriod.value,
              onChanged: (value) {
                visitedPeriods.value = {...visitedPeriods.value, value};
                selectedPeriod.value = value;
              },
              itemLabelBuilder: (value) => value.label,
            ),
          ),
          gapH8,
          Expanded(
            child: IndexedStack(
              index: selectedPeriod.value.index,
              children: [
                for (final period in SellersPeriod.values)
                  if (visitedPeriods.value.contains(period))
                    SellersPeriodView(
                      enterpriseId: enterpriseId,
                      period: period,
                    )
                  else
                    const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
