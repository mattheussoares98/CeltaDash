import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
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
