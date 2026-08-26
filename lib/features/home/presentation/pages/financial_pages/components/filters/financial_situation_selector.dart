part of 'financial_selectors_filters.dart';

class _FinancialSituationSelector extends ConsumerWidget {
  const _FinancialSituationSelector();

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
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformIcon(
              materialIcon: Icons.filter_alt_outlined,
              cupertinoIcon: CupertinoIcons.line_horizontal_3_decrease,
              size: Sizes.p16,
              color: theme.primaryColor,
            ),
            gapW4,
            BaseText.caption(
              '${situations.length}/${FinancialTitleSituation.values.length}',
              fontWeight: FontWeight.w600,
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
