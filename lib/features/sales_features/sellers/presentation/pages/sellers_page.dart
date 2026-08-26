// lib/features/sellers/presentation/pages/sellers_page.dart
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/features/sales_features/sellers/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          SellersContent(enterpriseId: enterpriseId),
    );
  }
}
