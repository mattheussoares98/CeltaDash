import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeModeToggle extends ConsumerWidget {
  const HomeModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider).value;
    if (homeState == null) return const LoadingCircle();

    final enterprisesAsync = ref.watch(enterprisesControllerProvider);
    final enterprises = enterprisesAsync.value;
    if (enterprises == null) return const LoadingCircle();

    final selectedEnterpriseIsDisabled =
        homeState.selectedEnterpriseId != null &&
        ref.watch(
          enterprisesControllerProvider.select(
            (s) =>
                s.value
                    ?.firstWhereOrNull(
                      (e) => e.id == homeState.selectedEnterpriseId,
                    )
                    ?.enabled ==
                false,
          ),
        );

    final theme = context.theme;
    final selectedModeLabel = switch (homeState.appMode) {
      AppMode.sales => 'Vendas'.hardcoded,
      AppMode.financialTitles => 'Financeiro'.hardcoded,
      AppMode.buyMovements => 'Compras'.hardcoded,
    };

    return PopupMenuButton<AppMode>(
      key: const ValueKey('home_mode_selector'),
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.p16)),
      enabled: !selectedEnterpriseIsDisabled,
      tooltip: 'Alterar modo'.hardcoded,
      initialValue: homeState.appMode,
      clipBehavior: .hardEdge,
      onSelected: (mode) async {
        final routeName = switch (mode) {
          AppMode.sales => Routes.salesHomeResume.name,
          AppMode.financialTitles => Routes.financialHomeResume.name,
          AppMode.buyMovements => Routes.buyMovementHomeResume.name,
        };

        try {
          await ref.read(homeControllerProvider.notifier).selectAppMode(mode);
          if (!context.mounted) return;
          context.goNamed(routeName);
        } catch (error) {
          showToastMessage(error.toString(), type: ToastType.error);
        }
      },
      itemBuilder: (context) => [
        for (final mode in AppMode.values)
          PopupMenuItem(
            value: mode,
            child: Row(
              children: [
                if (mode == homeState.appMode)
                  PlatformIcon(
                    materialIcon: Icons.check,
                    cupertinoIcon: CupertinoIcons.check_mark,
                    size: Sizes.p16,
                    color: theme.primaryColor,
                  )
                else
                  const SizedBox(width: Sizes.p16),
                gapW8,
                Expanded(
                  child: BaseText.bodyMedium(
                    switch (mode) {
                      AppMode.sales => 'Vendas'.hardcoded,
                      AppMode.financialTitles => 'Financeiro'.hardcoded,
                      AppMode.buyMovements => 'Compras'.hardcoded,
                    },
                    fontWeight: mode == homeState.appMode
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: mode == homeState.appMode
                        ? theme.primaryColor
                        : null,
                  ),
                ),
              ],
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
              materialIcon: Icons.swap_horiz,
              cupertinoIcon: CupertinoIcons.arrow_2_squarepath,
              size: Sizes.p16,
              color: theme.primaryColor,
            ),
            gapW4,
            Flexible(
              child: BaseText.caption(
                selectedModeLabel,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
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
