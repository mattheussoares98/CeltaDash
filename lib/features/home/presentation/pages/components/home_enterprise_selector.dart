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
    final enterprisesAsync = ref.watch(enterprisesControllerProvider);
    final enterprises = enterprisesAsync.value;
    if (homeState == null || enterprises == null) return const LoadingWidget();

    final currentIndex = enterprises.indexWhere(
      (enterprise) => enterprise.id == homeState.selectedEnterpriseId,
    );

    int? previousEnterpriseId;
    if (currentIndex > 0) {
      for (int i = currentIndex - 1; i >= 0; i--) {
        if (enterprises[i].enabled) {
          previousEnterpriseId = enterprises[i].id;
          break;
        }
      }
    }

    int? nextEnterpriseId;
    final startIndex = currentIndex < 0 ? 0 : currentIndex + 1;
    for (int i = startIndex; i < enterprises.length; i++) {
      if (enterprises[i].enabled) {
        nextEnterpriseId = enterprises[i].id;
        break;
      }
    }

    final bool isLoading = enterprisesAsync.isLoading;
    final notifier = ref.read(homeControllerProvider.notifier);

    return BaseDropDown<int>(
      key: const ValueKey('home_enterprise_selector'),
      label: 'Empresa'.hardcoded,
      selectedItem: homeState.selectedEnterpriseId,
      onChanged: isLoading ? null : notifier.selectEnterprise,
      onPrevious: !isLoading && previousEnterpriseId != null
          ? () => notifier.selectEnterprise(previousEnterpriseId!)
          : null,
      onNext: !isLoading && nextEnterpriseId != null
          ? () => notifier.selectEnterprise(nextEnterpriseId!)
          : null,
      items: enterprises.map((enterprise) {
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
