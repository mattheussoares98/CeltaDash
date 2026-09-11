import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/web_enterprises/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RemoteEnterprisesView extends HookConsumerWidget {
  const RemoteEnterprisesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(remoteEnterprisesControllerProvider);
    final enterpriseController = useTextEditingController();

    return AsyncValueWidget(
      value: enterprises,
      preserveValue: true,
      tryAgain: () => ref.invalidate(remoteEnterprisesControllerProvider),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: BaseText.error('Nenhuma empresa encontrada'.hardcoded),
          );
        }

        return AnimatedBuilder(
          animation: enterpriseController,
          builder: (context, _) {
            final filteredItems = enterpriseController.text.isEmpty
                ? items
                : items
                      .where(
                        (item) =>
                            item.enterpriseName?.toLowerCase().trim().contains(
                              enterpriseController.text.toLowerCase().trim(),
                            ) ??
                            false,
                      )
                      .toList();

            return Column(
              children: [
                BaseTextFormField(
                  controller: enterpriseController,
                  hintText: 'Filtrar empresa'.hardcoded,
                  labelText: 'Filtrar empresa'.hardcoded,
                  suffixIcon: BaseIconButton(
                    onPressed: enterpriseController.text.trim().isEmpty
                        ? null
                        : enterpriseController.clear,
                    platformIcon: PlatformIcon(
                      materialIcon: Icons.clear,
                      cupertinoIcon: Icons.clear,
                      color: context.colorScheme.error,
                    ),
                  ),
                ),
                gapH8,
                Expanded(
                  child: ResponsiveListFlow(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final enterprise = filteredItems[index];
                      return Card(
                        clipBehavior: .hardEdge,
                        child: BaseListTile(
                          onTap: () => showModalPage(
                            EnterpriseEditor(enterprise: enterprise),
                            context,
                          ),
                          contentPadding: const .symmetric(
                            horizontal: Sizes.p8,
                          ),
                          leading: const PlatformIcon(
                            materialIcon: Icons.business,
                            cupertinoIcon: Icons.business,
                          ),
                          title: BaseText.title(
                            enterprise.enterpriseName?.toUpperCase() ??
                                'Empresa sem identificação'.hardcoded,
                          ),
                          subtitle: Column(
                            children: [
                              if (enterprise.baseUrl != null)
                                BaseText(enterprise.baseUrl!),
                              Builder(
                                builder: (context) {
                                  getEnterprisesLength(bool enabled) =>
                                      enterprise.firebaseSubEnterprises?.where(
                                        (e) => e.enabled == enabled,
                                      );
                                  final enabled = getEnterprisesLength(true);
                                  final disabled = getEnterprisesLength(false);

                                  return BaseText(
                                    '${enabled?.length ?? 0} ativas - ${disabled?.length ?? 0} inativas',
                                  );
                                },
                              ),
                            ],
                          ),
                          trailing: const PlatformIcon(
                            materialIcon: Icons.edit,
                            cupertinoIcon: Icons.edit,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
