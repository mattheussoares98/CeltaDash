// lib/features/home/presentation/pages/personalized/components/personalized_date_selector.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PersonalizedDateSelector extends HookConsumerWidget {
  const PersonalizedDateSelector({super.key, this.onDateRangeCompleted});

  final VoidCallback? onDateRangeCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = ref.watch(
      personalizedControllerProvider.select((s) => s.startDate),
    );
    final endDate = ref.watch(
      personalizedControllerProvider.select((s) => s.endDate),
    );
    final isGenerating = ref.watch(
      personalizedControllerProvider.select((s) => s.isGenerating),
    );

    final formatter = DateFormat('dd/MM/yyyy'); //TODO use extension
    final now = DateTime.now();

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            //TODO copy secondary button from service providers project and put it here
            onPressed: isGenerating
                ? null
                : () async {
                    final picked = await GetNewDate.get(
                      context: context,
                      insertHoursAndMinutes: false,
                      currentSelectedDate: startDate ?? now,
                      minimumDate: now.subtract(const Duration(days: 365 * 5)),
                      maximumDate: now,
                    );
                    if (picked == null || !context.mounted) return;
                    ref
                        .read(personalizedControllerProvider.notifier)
                        .setDateRange(picked, null);
                    if (endDate != null) {
                      onDateRangeCompleted?.call();
                    }
                  },
            icon: PlatformIcon(
              materialIcon: Icons.calendar_today,
              cupertinoIcon: CupertinoIcons.calendar,
              size: Sizes.p16,
              color: context.colorScheme.primary,
            ),
            label: BaseText.bodySmall(
              startDate != null
                  ? formatter.format(startDate)
                  : 'Data inicial'.hardcoded,
              fontWeight: startDate != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
        gapW8,
        Expanded(
          child: OutlinedButton.icon(
            //TODO copy secondaryButton from serviceProviders and use it here
            onPressed: isGenerating
                ? null
                : () async {
                    final picked = await GetNewDate.get(
                      context: context,
                      insertHoursAndMinutes: false,
                      currentSelectedDate: endDate ?? startDate ?? now,
                      minimumDate:
                          startDate ??
                          now.subtract(const Duration(days: 365 * 5)),
                      maximumDate: now,
                    );
                    if (picked == null || !context.mounted) return;
                    ref
                        .read(personalizedControllerProvider.notifier)
                        .setDateRange(null, picked);
                    if (startDate != null) {
                      onDateRangeCompleted?.call();
                    }
                  },
            icon: PlatformIcon(
              materialIcon: Icons.event,
              cupertinoIcon: CupertinoIcons.calendar_today,
              size: Sizes.p16,
              color: context.colorScheme.primary,
            ),
            label: BaseText.bodySmall(
              endDate != null
                  ? formatter.format(endDate)
                  : 'Data final'.hardcoded,
              fontWeight: endDate != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
