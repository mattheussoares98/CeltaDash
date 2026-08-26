import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/resume/components/components.dart';
import 'package:flutter/material.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          ResumeContent(enterpriseId: enterpriseId),
    );
  }
}
