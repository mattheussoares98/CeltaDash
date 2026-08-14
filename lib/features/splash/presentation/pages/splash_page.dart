import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/splash/domain/domain.dart';
import 'package:celta_dash/features/splash/presentation/controllers/controllers.dart';
import 'package:celta_dash/routing/routes.dart';
import 'package:celta_dash/utils/constants/constants.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onAnimationComplete() async {
      final destination = await ref.read(splashControllerProvider.future);

      if (!context.mounted) return;

      switch (destination) {
        case SplashDestination.home:
          context.goNamed(Routes.home.name);
          break;
        case SplashDestination.login:
          context.goNamed(Routes.login.name);
          break;
        case SplashDestination.updateRequired:
          context.goNamed(Routes.updateAppVersion.name);
          break;
      }
    }

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      body: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
          child: LogoWidget(
            animate: true,
            animationDuration: const Duration(milliseconds: 3500),
            onAnimationComplete: onAnimationComplete,
          ),
        ),
      ),
    );
  }
}
