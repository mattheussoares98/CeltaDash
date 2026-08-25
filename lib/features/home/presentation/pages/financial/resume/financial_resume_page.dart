// lib/features/home/presentation/pages/financial/resume/financial_resume_page.dart
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/financial/resume/components/components.dart';
import 'package:flutter/material.dart';

class FinancialResumePage extends StatelessWidget {
  const FinancialResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          FinancialResumeContent(enterpriseId: enterpriseId),
    );
  }
}
