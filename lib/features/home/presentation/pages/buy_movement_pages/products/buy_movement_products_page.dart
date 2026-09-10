import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/products/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:flutter/material.dart';

class BuyMovementProductsPage extends StatelessWidget {
  const BuyMovementProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          BuyMovementProductsContent(enterpriseId: enterpriseId),
    );
  }
}
