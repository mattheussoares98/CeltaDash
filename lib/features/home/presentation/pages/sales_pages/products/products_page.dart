// lib/features/home/presentation/pages/products/products_page.dart
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/products/components/components.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          ProductsContent(enterpriseId: enterpriseId),
    );
  }
}
