// lib/features/home/presentation/pages/sales/sales_page.dart
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/sales/components/components.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          SalesContent(enterpriseId: enterpriseId),
    );
  }
}
