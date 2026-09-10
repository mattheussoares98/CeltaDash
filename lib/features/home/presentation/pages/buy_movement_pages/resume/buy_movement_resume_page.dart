import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/resume/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:flutter/material.dart';

class BuyMovementResumePage extends StatelessWidget {
  const BuyMovementResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          BuyMovementResumeContent(enterpriseId: enterpriseId),
    );
  }
}
