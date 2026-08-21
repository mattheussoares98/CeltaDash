import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/enterprises_manager/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SavedEnterprisesList extends ConsumerWidget {
  const SavedEnterprisesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managerState = ref.watch(
      enterprisesManagerControllerProvider.select((value) => value.value),
    );
    final enterprises = managerState?.enterprises ?? const [];
    if (enterprises.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p32),
          child: Center(
            child: BaseText.bodyMedium('Nenhuma empresa adicionada'.hardcoded),
          ),
        ),
      );
    }

    return SliverList.separated(
      //TODO ResponsiveListFlow
      itemCount: enterprises.length,
      separatorBuilder: (_, _) => gapH8,
      itemBuilder: (context, index) {
        final enterprise = enterprises[index];
        final isSelected = managerState?.isSelected(enterprise) == true;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(Sizes.p12),
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant,
            ),
          ),
          child: BaseListTile(
            title: BaseText.titleMedium(
              enterprise.enterpriseName?.toUpperCase() ?? '-'.hardcoded,
            ),
            subtitle: enterprise.bsUser?.name == null
                ? null
                : BaseText.bodySmall(enterprise.bsUser!.name!),
            trailing: isSelected
                ? const PlatformIcon(
                    materialIcon: Icons.check_circle,
                    cupertinoIcon: CupertinoIcons.check_mark_circled_solid,
                  )
                : BaseIconButton(
                    onPressed: () async {
                      final confirmed = await showAlertDialog(
                        context: context,
                        title: 'Remover empresa?'.hardcoded,
                        content: enterprise.enterpriseName,
                        cancelActionText: 'Cancelar'.hardcoded,
                        defaultActionText: 'Remover'.hardcoded,
                      );
                      if (confirmed != true) return;
                      await ref
                          .read(enterprisesManagerControllerProvider.notifier)
                          .removeEnterprise(enterprise);
                    },
                    platformIcon: const PlatformIcon(
                      materialIcon: Icons.delete_outline,
                      cupertinoIcon: CupertinoIcons.delete,
                    ),
                  ),
            onTap: isSelected
                ? null
                : () async {
                    final success = await ref
                        .read(enterprisesManagerControllerProvider.notifier)
                        .selectEnterprise(enterprise);
                    if (success && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
          ),
        );
      },
    );
  }
}
