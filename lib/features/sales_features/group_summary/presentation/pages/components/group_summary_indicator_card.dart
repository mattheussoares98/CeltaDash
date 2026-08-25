// lib/features/group_summary/presentation/pages/components/group_summary_indicator_card.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class GroupSummaryIndicatorCard extends StatelessWidget {
  const GroupSummaryIndicatorCard({
    required this.firstTitle,
    required this.firstValue,
    required this.secondTitle,
    required this.secondValue,
    required this.platformIcon,
    super.key,
  });

  final String firstTitle;
  final String firstValue;
  final String secondTitle;
  final String secondValue;
  final PlatformIcon platformIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(Sizes.p12),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: platformIcon.copyWith(
                color: context.theme.colorScheme.onPrimaryContainer,
                size: Sizes.p32,
              ),
            ),
            gapW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText.bodySmall(
                    firstTitle,
                    color: context.theme.hintColor,
                  ),
                  gapH4,
                  BaseText.titleMedium(firstValue, fontWeight: FontWeight.bold),
                  gapH12,
                  BaseText.bodySmall(
                    secondTitle,
                    color: context.theme.hintColor,
                  ),
                  gapH4,
                  BaseText.titleMedium(
                    secondValue,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
