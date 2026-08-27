// lib/features/home/presentation/pages/personalized/components/personalized_period_tile.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalizedPeriodTile extends HookConsumerWidget {
  const PersonalizedPeriodTile({
    super.key,
    required this.controller,
    this.onPeriodSelected,
  });

  final ExpansibleController controller;
  final VoidCallback? onPeriodSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(
      personalizedControllerProvider.select((s) => s.periodGrouping),
    );

    final titleText = selectedPeriod != null
        ? '${'Agrupamento por período:'.hardcoded} (${selectedPeriod.label})'
        : 'Agrupamento por período'.hardcoded;

    return ExpansionTile(
      controller: controller,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p8),
      ),
      title: BaseText.bodyMedium(
        titleText,
        fontWeight: selectedPeriod != null
            ? FontWeight.bold
            : FontWeight.normal,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        RadioGroup<PeriodGroupingType?>(
          groupValue: selectedPeriod,
          onChanged: (value) {
            ref
                .read(personalizedControllerProvider.notifier)
                .setPeriodGrouping(value);
            onPeriodSelected?.call();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: PeriodGroupingType.values.map((period) {
              final isSelected = period == selectedPeriod;
              return RadioListTile<PeriodGroupingType?>(
                dense: true,
                value: period,
                title: BaseText.bodyMedium(
                  period.label.hardcoded,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
