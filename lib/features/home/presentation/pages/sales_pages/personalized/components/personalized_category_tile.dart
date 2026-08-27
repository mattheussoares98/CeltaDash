// lib/features/home/presentation/pages/personalized/components/personalized_category_tile.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalizedCategoryTile extends HookConsumerWidget {
  const PersonalizedCategoryTile({super.key, required this.controller});

  final ExpansibleController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(
      personalizedControllerProvider.select((s) => s.categoryGroupings),
    );

    final hasSelections = selectedCategories.isNotEmpty;
    final selectedNames = selectedCategories.map((c) => c.label).join(', ');
    final titleText = hasSelections
        ? '${'Agrupamento por categoria:'.hardcoded} ($selectedNames)'
        : 'Agrupamento por categoria'.hardcoded;

    return ExpansionTile(
      controller: controller,
      dense: true,
      title: BaseText.bodyMedium(
        titleText,
        fontWeight: hasSelections ? FontWeight.bold : FontWeight.normal,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      children: CategoryGroupingType.values.map((category) {
        final isSelected = selectedCategories.contains(category);
        return CheckboxListTile(
          dense: true,
          value: isSelected,
          title: BaseText.bodyMedium(
            category.label.hardcoded,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onChanged: (_) {
            ref
                .read(personalizedControllerProvider.notifier)
                .toggleCategoryGrouping(category);
          },
        );
      }).toList(),
    );
  }
}
