import 'package:celta_dash/features/goal_historic/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter/material.dart';

class GoalHistoricPage extends StatelessWidget {
  const GoalHistoricPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) => GoalHistoricContent(
        enterpriseId: enterpriseId,
      ),
    );
  }
}
