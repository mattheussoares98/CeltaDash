import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompareDaysDateSelector extends ConsumerWidget {
  const CompareDaysDateSelector({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(compareDaysDatesControllerProvider);

    final datesController = ref.read(
      compareDaysDatesControllerProvider.notifier,
    );
    final isLoading = ref.watch(
      compareDaysControllerProvider(enterpriseId).select((s) => s.isLoading),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: Row(
        children: [
          Expanded(
            child: _DateButton(
              date: dates.firstDay,
              isLoading: isLoading,
              onSelected: datesController.selectFirstDay,
            ),
          ),
          gapW8,
          Expanded(
            child: _DateButton(
              date: dates.secondDay,
              isLoading: isLoading,
              onSelected: datesController.selectSecondDay,
            ),
          ),
          gapW8,
          BaseIconButton(
            onPressed: isLoading
                ? null
                : ref
                      .read(
                        compareDaysControllerProvider(enterpriseId).notifier,
                      )
                      .refresh,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.refresh,
              cupertinoIcon: CupertinoIcons.refresh,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.date,
    required this.isLoading,
    required this.onSelected,
  });

  final DateTime date;
  final bool isLoading;
  final String? Function(DateTime date) onSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : () async {
              final selected = await GetNewDate.get(
                context: context,
                currentSelectedDate: date,
                minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                maximumDate: DateTime.now(),
                insertHoursAndMinutes: false,
              );
              if (selected == null) return;
              final error = onSelected(selected);
              if (error != null && context.mounted) {
                showToastMessage(error.hardcoded, type: ToastType.error);
              }
            },
      icon: const PlatformIcon(
        materialIcon: Icons.calendar_month,
        cupertinoIcon: CupertinoIcons.calendar,
      ),
      label: FittedBox(child: Text(date.formatDate())),
    );
  }
}
