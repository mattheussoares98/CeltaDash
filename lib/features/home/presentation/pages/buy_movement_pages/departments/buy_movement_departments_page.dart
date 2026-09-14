import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/departments/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:flutter/material.dart';

class BuyMovementDepartmentsPage extends StatelessWidget {
  const BuyMovementDepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          BuyMovementDepartmentsContent(enterpriseId: enterpriseId),
    );
  }
}
