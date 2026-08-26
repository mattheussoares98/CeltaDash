import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/extensions/extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDateSelector extends ConsumerWidget {
  const HomeDateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider).value;
    final enterprisesAsync = ref.watch(enterprisesControllerProvider);
    final enterprises = enterprisesAsync.value;
    if (homeState == null || enterprises == null) return const LoadingCircle();

    final selectedEnterpriseIsDisabled =
        homeState.selectedEnterpriseId != null &&
        ref.watch(
          enterprisesControllerProvider.select(
            (s) =>
                s.value
                    ?.firstWhereOrNull(
                      (e) => e.id == homeState.selectedEnterpriseId,
                    )
                    ?.enabled ==
                false,
          ),
        );

    return PrimaryButton(
      key: const ValueKey('home_date_selector'),
      text: homeState.selectedDate.formatDate(),
      isLoading: enterprisesAsync.isLoading,
      onPressed: selectedEnterpriseIsDisabled
          ? null
          : () async {
              final newDate = await GetNewDate.get(
                context: context,
                currentSelectedDate: homeState.selectedDate,
                minimumDate: DateTime.now().subtract(
                  const Duration(days: 1825),
                ),
                maximumDate: DateTime.now(),
                insertHoursAndMinutes: false,
              );
              if (newDate != null) {
                ref.read(homeControllerProvider.notifier).selectDate(newDate);
              }
            },
      icon: const PlatformIcon(
        materialIcon: Icons.date_range,
        cupertinoIcon: CupertinoIcons.calendar,
      ),
    );
  }
}
