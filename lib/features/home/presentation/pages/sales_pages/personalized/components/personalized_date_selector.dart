// lib/features/home/presentation/pages/personalized/components/personalized_date_selector.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalizedDateSelector extends StatelessWidget {
  const PersonalizedDateSelector({super.key, this.onDateRangeCompleted});

  final VoidCallback? onDateRangeCompleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _UpdateDate(
            isStartDate: true,
            onDateRangeCompleted: onDateRangeCompleted,
          ),
        ),
        gapW8,
        Expanded(
          child: _UpdateDate(
            isStartDate: false,
            onDateRangeCompleted: onDateRangeCompleted,
          ),
        ),
      ],
    );
  }
}

class _UpdateDate extends ConsumerWidget {
  const _UpdateDate({
    required this.isStartDate,
    required this.onDateRangeCompleted,
  });
  final bool isStartDate;
  final VoidCallback? onDateRangeCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(
      personalizedControllerProvider.select(
        (s) => isStartDate ? s.startDate : s.endDate,
      ),
    );
    final isGenerating = ref.watch(
      personalizedControllerProvider.select((s) => s.isGenerating),
    );

    final now = DateTime.now();

    return SecondaryButton(
      text: date != null
          ? date.formatDate()
          : isStartDate
          ? 'Data inicial'.hardcoded
          : 'Data final',
      platformIcon: PlatformIcon(
        materialIcon: Icons.calendar_today,
        cupertinoIcon: CupertinoIcons.calendar,
        size: Sizes.p16,
        color: context.colorScheme.primary,
      ),
      onTap: isGenerating
          ? null
          : () async {
              final picked = await GetNewDate.get(
                context: context,
                insertHoursAndMinutes: false,
                currentSelectedDate: date ?? now,
                minimumDate: now.subtract(const Duration(days: 365 * 5)),
                maximumDate: now,
              );
              if (picked == null || !context.mounted) return;
              ref
                  .read(personalizedControllerProvider.notifier)
                  .setDateRange(
                    isStartDate ? picked : null,
                    isStartDate ? null : picked,
                  );
              if (date != null) {
                onDateRangeCompleted?.call();
              }
            },
    );
  }
}
