import 'package:flutter/material.dart';

import '../../pages.dart';

class PaymentFinalizations extends StatelessWidget {
  const PaymentFinalizations({
    super.key,
    required this.sale,
  });

  final EcSaleMovementViewModel? sale;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sale?.paymentFinalizations?.length,
      itemBuilder: (context, index) {
        final finalization = sale?.paymentFinalizations![index];
        return Column(
          children: [
            Text(finalization?.Id ?? ""),
            Text(finalization?.QuantityOfPortions ?? ""),
            Text(finalization?.Value ?? ""),
            Text(finalization?.DateOfExpiration ?? ""),
            Text(finalization?.Finalization?.Name ?? ""),
          ],
        );
      },
    );
  }
}
