import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/payments/presentation/presentation.dart';
import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      builder: (context, enterpriseId) => const PaymentsContent(),
    );
  }
}
