import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/goal_historic/presentation/pages/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoalHistoricContent extends ConsumerWidget {
  const GoalHistoricContent({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      appBar: HomeAppBar(
        isLandscape: false,
        showSelectDate: false,
        leading: BaseIconButton(
          onPressed: context.pop,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.back,
            materialIcon: Icons.arrow_back,
          ),
        ),
        leftDateWidget: GoalHistoricYearSelector(enterpriseId: enterpriseId),
      ),
      isScrollable: false,
      usePadding: false,
      body: GoalHistoricTable(enterpriseId: enterpriseId),
    );
  }
}
