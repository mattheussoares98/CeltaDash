import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
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
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.clear,
                      cupertinoIcon: Icons.clear,
                      color: Colors.red,
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
                        child: BaseListTile(
                          contentPadding: const .only(left: Sizes.p8),
                          leading: const PlatformIcon(
                            materialIcon: Icons.business,
                            cupertinoIcon: Icons.business,
                          ),
                          title: BaseText.title(
                            enterprise.enterpriseName?.toUpperCase() ??
                                'Empresa sem identificação'.hardcoded,
                          ),
                          subtitle: enterprise.baseUrl == null
                              ? null
                              : BaseText(enterprise.baseUrl!),
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
