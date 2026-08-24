import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeDrawer extends HookConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: GestureDetector(
                onLongPress: () {
                  context.pop();
                  context.pushNamed(Routes.webLogin.name);
                },
                child: const LogoWidget(),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _DrawerSectionTitle(
                    title: 'Relatórios & consultas'.hardcoded,
                  ),
                  _DrawerItem(
                    title: 'Personalizado'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.assignment_ind,
                      cupertinoIcon: CupertinoIcons.doc_person,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.homePersonalized.name);
                    },
                  ),
                  _DrawerItem(
                    title: 'Vendedores'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.people,
                      cupertinoIcon: CupertinoIcons.person_3,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.sellers.name);
                    },
                  ),
                  _DrawerItem(
                    title: 'Operadores'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.badge,
                      cupertinoIcon: CupertinoIcons.person_badge_plus,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.operators.name);
                    },
                  ),
                  _DrawerItem(
                    title: 'Vendas'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.sell,
                      cupertinoIcon: CupertinoIcons.money_dollar,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.sales.name);
                    },
                  ),
                  _DrawerItem(
                    title: 'Comparativo diário'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.compare_arrows,
                      cupertinoIcon: CupertinoIcons.arrow_right_arrow_left,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.compareDays.name);
                    },
                  ),
                  _DrawerItem(
                    title: 'Comparativo mensal'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.calendar_month,
                      cupertinoIcon: CupertinoIcons.calendar,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.compareMonths.name);
                    },
                  ),
                  const Divider(),
                  _DrawerSectionTitle(title: 'Sistema'.hardcoded),
                  _DrawerItem(
                    title: 'Gerenciar empresas'.hardcoded,
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.manage_accounts,
                      cupertinoIcon: CupertinoIcons.person_2,
                    ),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.enterprisesManager.name);
                    },
                  ),
                  //TODO add option to toggle app mode
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerItem(
              title: 'Sair'.hardcoded,
              textColor: context.colorScheme.error,
              platformIcon: PlatformIcon(
                materialIcon: Icons.logout,
                cupertinoIcon: CupertinoIcons.square_arrow_right,
                color: context.colorScheme.error,
              ),
              onTap: () async {
                final confirmed = await showAlertDialog(
                  context: context,
                  title: 'Deseja realmente sair?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Sair'.hardcoded,
                );
                if (confirmed != true || !context.mounted) return;

                try {
                  context.pop();
                  await ref.read(homeControllerProvider.notifier).logout();
                  if (context.mounted) context.goNamed(Routes.splash.name);
                } catch (error) {
                  showToastMessage(
                    error.toString().hardcoded,
                    type: ToastType.error,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  const _DrawerSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p4,
      ),
      child: BaseText.bodySmall(
        title,
        fontWeight: FontWeight.bold,
        color: context.colorScheme.primary,
        textAlign: .center,
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.title,
    required this.platformIcon,
    required this.onTap,
    this.textColor,
  });

  final String title;
  final PlatformIcon platformIcon;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return BaseListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      leading: platformIcon,
      title: BaseText.bodyMedium(
        title,
        color: textColor ?? context.colorScheme.onSurface,
      ),
      onTap: onTap,
    );
  }
}
