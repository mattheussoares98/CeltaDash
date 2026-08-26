import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/features/sales_features/operators/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';

class OperatorsPage extends StatelessWidget {
  const OperatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          OperatorsContent(enterpriseId: enterpriseId),
    );
  }
}
