import 'package:flutter/material.dart';

import '../../pages.dart';

class Customer extends StatelessWidget {
  const Customer({
    super.key,
    required this.sale,
  });

  final EcSaleMovementViewModel? sale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(sale?.customer?.CpfCnpj ?? ""),
        Text(sale?.customer?.Id ?? ""),
        Text(sale?.customer?.Name ?? ""),
        Text(sale?.customer?.SaleMovementId ?? ""),
      ],
    );
  }
}
