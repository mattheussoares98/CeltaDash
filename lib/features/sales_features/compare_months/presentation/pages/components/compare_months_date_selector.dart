import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/compare_months/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompareMonthsDateSelector extends ConsumerWidget {
  const CompareMonthsDateSelector({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(compareMonthsDatesControllerProvider);
    final datesController = ref.read(
      compareMonthsDatesControllerProvider.notifier,
    );
    final isLoading = ref.watch(
      compareMonthsControllerProvider(enterpriseId).select((s) => s.isLoading),
    );

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _PeriodSelector(
              title: '1º Período'.hardcoded,
              selectedDate: dates.firstMonth,
              isLoading: isLoading,
              onDateChanged: (newDate) {
                final error = datesController.selectFirstMonth(newDate);
                if (error != null && context.mounted) {
                  showToastMessage(error, type: ToastType.error);
                }
              },
            ),
          ),
          const VerticalDivider(thickness: 0.2),
          Expanded(
            child: _PeriodSelector(
              title: '2º Período'.hardcoded,
              selectedDate: dates.secondMonth,
              isLoading: isLoading,
              onDateChanged: (newDate) {
                final error = datesController.selectSecondMonth(newDate);
                if (error != null && context.mounted) {
                  showToastMessage(error, type: ToastType.error);
                }
              },
            ),
          ),
          gapW8,
          BaseIconButton(
            onPressed: isLoading
                ? null
                : ref
                      .read(
                        compareMonthsControllerProvider(enterpriseId).notifier,
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

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.title,
    required this.selectedDate,
    required this.isLoading,
    required this.onDateChanged,
  });

  final String title;
  final DateTime selectedDate;
  final bool isLoading;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseText.caption(title, fontStyle: .italic),
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: selectedDate.month,
                items: List.generate(12, (index) {
                  final month = index + 1;
                  return DropdownMenuItem<int>(
                    value: month,
                    child: BaseText(DateTime(0, month).formatDate(.MMMM)),
                  );
                }),
                onChanged: isLoading
                    ? null
                    : (month) {
                        if (month == null) return;
                        onDateChanged(DateTime(selectedDate.year, month));
                      },
              ),
              gapW4,
              DropdownButton<int>(
                value: selectedDate.year,
                items: List.generate(6, (index) {
                  final year = DateTime.now().year - index;
                  return DropdownMenuItem<int>(
                    value: year,
                    child: BaseText(year.toString()),
                  );
                }),
                onChanged: isLoading
                    ? null
                    : (year) {
                        if (year == null) return;
                        onDateChanged(DateTime(year, selectedDate.month));
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
