import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(104);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    ref.listen(
      homeControllerProvider.select((value) => value.value?.selectionError),
      (previous, next) {
        if (next == null || next == previous) return;
        showToastMessage(next.hardcoded, type: ToastType.error);
        ref.read(homeControllerProvider.notifier).clearSelectionError();
      },
    );

    final controls = AsyncValueWidget(
      value: homeAsync,
      tryAgain: () => ref.invalidate(homeControllerProvider),
      data: (_) {
        const enterpriseSelector = HomeEnterpriseSelector();
        const dateSelector = Expanded(child: HomeDateSelector());
        const modeToggle = Flexible(child: HomeModeToggle());

        if (MediaQuery.orientationOf(context) == Orientation.landscape) {
          return const Row(
            children: [
              dateSelector,
              gapW8,
              Expanded(child: enterpriseSelector),
              gapW8,
              modeToggle,
            ],
          );
        }
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            enterpriseSelector,
            gapH4,
            Row(children: [dateSelector, gapW8, modeToggle]),
          ],
        );
      },
    );

    return BaseAppBar(
      showLeading: false,
      titleWidget: controls,
      actionsPadding: const EdgeInsets.symmetric(vertical: Sizes.p24),
      actions: [
        BaseIconButton(
          key: const ValueKey('home_enterprises_manager'),
          onPressed: () => context.pushNamed(Routes.enterprisesManager.name),
          platformIcon: const PlatformIcon(
            materialIcon: Icons.manage_accounts,
            cupertinoIcon: CupertinoIcons.person_2,
          ),
        ),
      ],
    );
  }
}
