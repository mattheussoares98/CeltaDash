// lib/features/home/presentation/pages/financial/financial_periods_page.dart
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/financial/components/components.dart';
import 'package:flutter/material.dart';

class FinancialPeriodsPage extends StatelessWidget {
  const FinancialPeriodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          FinancialPeriodsContent(enterpriseId: enterpriseId),
    );
  }
}
