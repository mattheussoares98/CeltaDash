import 'package:celta_dash/features/canceled_sales/presentation/pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';

class CanceledSalesPage extends StatelessWidget {
  const CanceledSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          CanceledSalesContent(enterpriseId: enterpriseId),
    );
  }
}
