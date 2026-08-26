import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/resume/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthlyGoalInfoButton extends StatelessWidget {
  const MonthlyGoalInfoButton({
    super.key,
    required this.comparison,
    this.cachedGoal,
  });

  final MonthlyGoalComparisonState comparison;
  final MonthlyGoalEntity? cachedGoal;

  @override
  Widget build(BuildContext context) {
    return BaseIconButton(
      padding: .zero,
      onPressed: () {
        showAlertDialog(
          context: context,
          title: 'Informações sobre a meta'.hardcoded,
          contentWidget: MonthlyGoalInfoContent(
            comparison: comparison,
            cachedGoal: cachedGoal,
          ),
        );
      },
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.info,
        materialIcon: Icons.info,
        color: context.theme.colorScheme.primary.withAlpha(200),
      ),
    );
  }
}
