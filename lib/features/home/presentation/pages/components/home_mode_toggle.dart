import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeModeToggle extends ConsumerWidget {
  const HomeModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider).value;
    if (homeState == null) return const LoadingWidget();

    final enterprisesAsync = ref.watch(enterprisesControllerProvider);
    final enterprises = enterprisesAsync.value;
    if (enterprises == null) return const LoadingWidget();
    final selectedEnterpriseIsEnabled = enterprises.any(
      (enterprise) =>
          enterprise.id == homeState.selectedEnterpriseId && enterprise.enabled,
    );

    return PrimaryTextButton(
      key: const ValueKey('home_mode_toggle'),
      text: homeState.appMode == AppMode.sales
          ? 'Vendas'.hardcoded
          : 'Financeiro'.hardcoded,
      onPressed: selectedEnterpriseIsEnabled
          ? () async {
              try {
                await ref.read(homeControllerProvider.notifier).toggleAppMode();
              } catch (error) {
                showToastMessage(error.toString(), type: ToastType.error);
              }
            }
          : null,
      platformIcon: const PlatformIcon(
        materialIcon: Icons.compare_arrows,
        cupertinoIcon: CupertinoIcons.arrow_2_squarepath,
      ),
    );
  }
}
