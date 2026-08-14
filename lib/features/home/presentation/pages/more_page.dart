import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MorePage extends HookConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        title: 'More'.hardcoded,
        actions: [
          BaseIconButton(
            key: const ValueKey('logout_button'),
            onPressed: () async {
              final confirmed = await showAlertDialog(
                context: context,
                title: 'Do you really want to logout?'.hardcoded,
                cancelActionText: 'Cancel'.hardcoded,
                defaultActionText: 'Logout'.hardcoded,
              );
              if (confirmed != true || !context.mounted) return;

              try {
                await ref.read(homeControllerProvider.notifier).logout();
                if (context.mounted) context.goNamed(Routes.splash.name);
              } catch (error) {
                showToastMessage(
                  error.toString().hardcoded,
                  type: ToastType.error,
                );
              }
            },
            platformIcon: const PlatformIcon(
              materialIcon: Icons.logout,
              cupertinoIcon: CupertinoIcons.square_arrow_right,
            ),
          ),
        ],
      ),
      body: Center(child: BaseText.titleLarge('More'.hardcoded)),
    );
  }
}
