import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FinancialPeriodTypeSelector extends ConsumerWidget {
  const FinancialPeriodTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(
      homeFinancialFiltersControllerProvider.select(
        (state) => state.periodType,
      ),
    );
    final theme = context.theme;

    return PopupMenuButton<FinancialTitlePeriodType>(
      clipBehavior: .hardEdge,
      tooltip: 'Tipo de data do período'.hardcoded,
      initialValue: selectedType,
      onSelected: (type) {
        ref
            .read(homeFinancialFiltersControllerProvider.notifier)
            .setPeriodType(type);
      },
      itemBuilder: (context) => [
        for (final type in FinancialTitlePeriodType.values)
          PopupMenuItem(
            value: type,
            height: 38,
            child: Row(
              children: [
                if (type == selectedType)
                  PlatformIcon(
                    materialIcon: Icons.check,
                    cupertinoIcon: CupertinoIcons.check_mark,
                    size: 16,
                    color: theme.primaryColor,
                  )
                else
                  const SizedBox(width: 16),
                gapW8,
                Expanded(
                  child: BaseText(
                    type.label,
                    fontWeight: type == selectedType
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: type == selectedType ? theme.primaryColor : null,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(140),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformIcon(
              materialIcon: Icons.tune,
              cupertinoIcon: CupertinoIcons.slider_horizontal_3,
              size: 14,
              color: theme.primaryColor,
            ),
            gapW4,
            BaseText.caption(selectedType.label, fontWeight: FontWeight.w600),
            PlatformIcon(
              materialIcon: Icons.arrow_drop_down,
              cupertinoIcon: CupertinoIcons.chevron_down,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
