import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEnterpriseSelector extends ConsumerWidget {
  const HomeEnterpriseSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider).value;
    if (homeState == null) return const LoadingWidget();

    return BaseDropDown<int>(
      key: const ValueKey('home_enterprise_selector'),
      label: 'Empresa'.hardcoded,
      selectedItem: homeState.selectedEnterpriseId,
      onChanged: homeState.isRefreshing
          ? null
          : ref.read(homeControllerProvider.notifier).selectEnterprise,
      items: homeState.enterprises.map((enterprise) {
        final label = [
          enterprise.personalizedCode,
          enterprise.name,
        ].whereType<String>().where((value) => value.isNotEmpty).join(' - ');
        return DropdownMenuItem<int>(
          value: enterprise.id,
          enabled: enterprise.enabled,
          child: BaseText.bodyMedium(
            enterprise.enabled
                ? label.hardcoded
                : '$label (${'desabilitado'.hardcoded})',
            color: enterprise.enabled ? null : context.colorScheme.error,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
