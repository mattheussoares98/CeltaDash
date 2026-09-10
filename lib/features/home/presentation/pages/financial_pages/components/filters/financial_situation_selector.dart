import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialSituationSelector extends ConsumerWidget {
  const FinancialSituationSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final situations = ref.watch(
      homeFinancialFiltersControllerProvider.select(
        (state) => state.situations,
      ),
    );
    final theme = context.theme;

    return PopupMenuButton<FinancialTitleSituation>(
      clipBehavior: .hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.p16)),
      tooltip: 'Situações dos títulos'.hardcoded,
      onSelected: (situation) => ref
          .read(homeFinancialFiltersControllerProvider.notifier)
          .toggleSituation(situation),
      itemBuilder: (context) => [
        for (final situation in FinancialTitleSituation.values)
          CheckedPopupMenuItem(
            value: situation,
            checked: situations.contains(situation),
            child: Padding(
              padding: const EdgeInsets.only(left: Sizes.p8),
              child: BaseText(situation.label),
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p4,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(140),
          borderRadius: BorderRadius.circular(Sizes.p16),
          border: Border.all(color: theme.dividerColor.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            PlatformIcon(
              materialIcon: Icons.filter_alt_outlined,
              cupertinoIcon: CupertinoIcons.line_horizontal_3_decrease,
              size: Sizes.p16,
              color: theme.primaryColor,
            ),
            gapW4,
            Flexible(
              child: BaseText.caption(
                '${situations.length}/${FinancialTitleSituation.values.length}',
                fontWeight: FontWeight.w600,
              ),
            ),
            PlatformIcon(
              materialIcon: Icons.arrow_drop_down,
              cupertinoIcon: CupertinoIcons.chevron_down,
              size: Sizes.p16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
