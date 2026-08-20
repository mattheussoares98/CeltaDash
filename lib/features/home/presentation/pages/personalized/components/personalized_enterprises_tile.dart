// lib/features/home/presentation/pages/personalized/components/personalized_enterprises_tile.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalizedEnterprisesTile extends HookConsumerWidget {
  const PersonalizedEnterprisesTile({
    super.key,
    required this.controller,
    this.onEnterpriseSelected,
  });

  final ExpansibleController controller;
  final VoidCallback? onEnterpriseSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterpriseId = ref.watch(
      personalizedControllerProvider.select((s) => s.selectedEnterpriseId),
    );
    final enterprises = ref.watch(
      enterprisesControllerProvider.select((s) => s.value ?? []),
    );

    final selectedEnterprise = enterprises.firstWhereOrNull(
      (e) => e.id == selectedEnterpriseId,
    );

    final titleText = selectedEnterprise != null
        ? '${'Empresa:'.hardcoded} ${selectedEnterprise.personalizedCode} - ${selectedEnterprise.name}'
        : 'Empresa'.hardcoded;

    return ExpansionTile(
      controller: controller,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p8),
      ),
      title: BaseText.bodyMedium(
        titleText,
        fontWeight: selectedEnterprise != null
            ? FontWeight.bold
            : FontWeight.normal,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        RadioGroup<int?>(
          groupValue: selectedEnterpriseId,
          onChanged: (value) {
            if (value == null) return;
            ref
                .read(personalizedControllerProvider.notifier)
                .selectEnterprise(value);
            onEnterpriseSelected?.call();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: enterprises.map((enterprise) {
              final isSelected = enterprise.id == selectedEnterpriseId;
              return RadioListTile<int?>(
                dense: true,
                value: enterprise.id,
                title: BaseText.bodyMedium(
                  '${enterprise.personalizedCode} - ${enterprise.name}'
                      .hardcoded,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
