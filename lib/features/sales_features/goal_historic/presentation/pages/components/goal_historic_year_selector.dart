import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/goal_historic/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoalHistoricYearSelector extends ConsumerWidget {
  const GoalHistoricYearSelector({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(goalHistoricYearControllerProvider);
    final nowYear = DateTime.now().year;
    final currentYear = nowYear < 2025 ? 2025 : nowYear;
    final years = List<int>.generate(
      currentYear - 2025 + 1,
      (index) => currentYear - index,
    );

    final isLoading = ref.watch(
      goalHistoricControllerProvider(enterpriseId).select((s) => s.isLoading),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseText.bodyMedium('Ano'.hardcoded),
        gapW8,
        DropdownButton<int>(
          value: selectedYear,
          items: years.map((year) {
            return DropdownMenuItem<int>(
              value: year,
              child: BaseText(year.toString()),
            );
          }).toList(),
          onChanged: isLoading
              ? null
              : (year) {
                  if (year == null) return;
                  ref
                      .read(goalHistoricYearControllerProvider.notifier)
                      .selectYear(year);
                },
        ),
        if (!PlatformUtil.isMobile) ...[
          gapW16,
          BaseIconButton(
            onPressed: isLoading
                ? null
                : () => ref.invalidate(
                    goalHistoricControllerProvider(enterpriseId),
                  ),
            platformIcon: const PlatformIcon(
              materialIcon: Icons.refresh,
              cupertinoIcon: CupertinoIcons.refresh,
            ),
          ),
        ],
      ],
    );
  }
}
