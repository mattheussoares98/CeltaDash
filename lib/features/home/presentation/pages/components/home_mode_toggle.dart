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

    return PrimaryTextButton(
      key: const ValueKey('home_mode_toggle'),
      text: homeState.appMode == AppMode.sales
          ? 'Financeiro'.hardcoded
          : 'Vendas'.hardcoded,
      onPressed: selectedEnterpriseIsDisabled
          ? null
          : () async {
              try {
                await ref.read(homeControllerProvider.notifier).toggleAppMode();
                if (!context.mounted) return;

                final appMode = ref.read(homeControllerProvider).value?.appMode;
                context.goNamed(
                  appMode == AppMode.financialTitles
                      ? Routes.financialHomeResume.name
                      : Routes.salesHomeResume.name,
                );
              } catch (error) {
                showToastMessage(error.toString(), type: ToastType.error);
              }
            },
      platformIcon: const PlatformIcon(
        materialIcon: Icons.compare_arrows,
        cupertinoIcon: CupertinoIcons.arrow_2_squarepath,
      ),
    );
  }
}
